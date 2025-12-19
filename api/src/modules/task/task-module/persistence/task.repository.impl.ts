import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { TransactionalRepository } from 'src/modules/unit-of-work/persistence/transactional.repository';
import { SortBy } from 'src/modules/workspace/workspace-module/dto/request/workspace-item-request.dto';
import { FindOptionsRelations, Repository } from 'typeorm';
import { TaskAssignmentEntity } from '../../task-assignment/persistence/task-assignment.entity';
import { ProgressStatus } from '../domain/progress-status.enum';
import { Task } from '../domain/task.domain';
import { TaskEntity } from './task.entity';
import { TaskRepository } from './task.repository';

@Injectable()
export class TaskRepositoryImpl implements TaskRepository {
  constructor(
    @InjectRepository(TaskEntity)
    private readonly repo: Repository<TaskEntity>,
    private readonly transactionalRepository: TransactionalRepository,
  ) {}

  async create({
    data,
    workspaceId,
    createdById,
    relations,
  }: {
    data: {
      title: Task['title'];
      description: Task['description'];
      rewardPoints: Task['rewardPoints'];
      dueDate: Task['dueDate'];
    };
    workspaceId: Task['workspace']['id'];
    createdById: Task['createdBy']['id'];
    relations?: FindOptionsRelations<TaskEntity>;
  }): Promise<Nullable<TaskEntity>> {
    const persistenceModel = this.repo.create({
      workspace: {
        id: workspaceId,
      },
      title: data.title,
      description: data.description,
      rewardPoints: data.rewardPoints,
      dueDate: data.dueDate,
      createdBy: { id: createdById },
    });

    const savedEntity = await this.transactionalTaskRepo.save(persistenceModel);

    const newEntity = await this.transactionalTaskRepo.findOne({
      where: { id: savedEntity.id },
      relations,
    });

    return newEntity;
  }

  async findById({
    id,
    relations,
  }: {
    id: Task['id'];
    relations?: FindOptionsRelations<TaskEntity>;
  }): Promise<Nullable<TaskEntity>> {
    return await this.repo.findOne({
      where: { id },
      relations,
    });
  }

  async findByTaskIdAndWorkspaceId({
    taskId,
    workspaceId,
    relations,
  }: {
    taskId: Task['id'];
    workspaceId: Task['workspace']['id'];
    relations?: FindOptionsRelations<TaskEntity>;
  }): Promise<Nullable<TaskEntity>> {
    return await this.repo.findOne({
      where: { id: taskId, workspace: { id: workspaceId } },
      relations,
    });
  }

  async findAllByWorkspaceId({
    workspaceId,
    query: { page, limit, status, search, sort },
  }: {
    workspaceId: string;
    query: {
      page: number;
      limit: number;
      status: ProgressStatus | null;
      search: string | null;
      sort: SortBy | null;
    };
  }): Promise<{
    data: TaskEntity[];
    totalPages: number;
    total: number;
  }> {
    // We use 2-phase query since a task can have multiple task assignments
    // (1:N relation) and to avoid group bys and distincts, and also possible
    // empty items resulting array, because resulting row multiplication can
    // happen and ruin pagination.
    // On 1:N relations, skip/take works on resulting rows, and not on entities
    // meaning it can skip one task which has 5 assignments (if skip was 5),
    // and not skip 5 tasks.

    // Phase 1: paginate only the "main" table: filtering and sorting only on
    // the Task table, take total and take tasks' IDs
    const baseQb = this.repo
      .createQueryBuilder('task')
      .where('task.workspace.id = :workspaceId', { workspaceId });

    if (status) {
      // Status filter: task has at least one assignment with the given status
      baseQb
        .andWhere((qb) => {
          const sub = qb
            .subQuery()
            .select('1')
            .from(TaskAssignmentEntity, 'ta')
            .where('ta.task.id = task.id')
            .andWhere('ta.status = :status')
            .getQuery();
          return `EXISTS ${sub}`;
        })
        .setParameter('status', status);
    }

    if (search) {
      baseQb.andWhere('LOWER(task.title) LIKE :search', {
        search: `%${search.toLowerCase()}%`,
      });
    }

    switch (sort) {
      case SortBy.NEWEST:
        baseQb.orderBy('task.createdAt', 'DESC');
        break;
      case SortBy.OLDEST:
        baseQb.orderBy('task.createdAt', 'ASC');
        break;
      default:
        baseQb.orderBy('task.createdAt', 'DESC');
    }

    const offset = (page - 1) * limit;
    // clone method is used because QB is not mutable and thread-safe
    const [idRows, totalCount] = await Promise.all([
      baseQb
        .clone()
        .select('task.id', 'id')
        .skip(offset)
        .take(limit)
        .getRawMany<{ id: string }>(),
      baseQb.clone().getCount(),
    ]);

    const ids = idRows.map((r) => r.id);

    // This can happen if the wanted page is > totalPages,
    // and total is pointing to the fact that there still
    // is data in the database, just not on this page
    if (ids.length === 0) {
      return {
        data: [],
        totalPages: Math.ceil(totalCount / limit),
        total: totalCount,
      };
    }

    // Phase 2: retrieval of needed relations for IDs from phase 1
    const data = await this.repo
      .createQueryBuilder('task')
      .whereInIds(ids)
      .leftJoinAndSelect('task.taskAssignments', 'assignment')
      .leftJoinAndSelect('assignment.assignee', 'assignee')
      .leftJoinAndSelect('assignee.user', 'user')
      .leftJoinAndSelect('task.createdBy', 'createdBy')
      .leftJoinAndSelect('createdBy.user', 'createdByUser')
      .orderBy('task.createdAt', sort === SortBy.OLDEST ? 'ASC' : 'DESC')
      .addOrderBy('user.firstName', 'ASC')
      .addOrderBy('user.lastName', 'ASC')
      .getMany();

    return {
      data,
      totalPages: Math.ceil(totalCount / limit),
      total: totalCount,
    };
  }

  async update({
    id,
    data,
    relations,
  }: {
    id: Task['id'];
    data: Partial<
      Omit<
        Task,
        | 'id'
        | 'createdAt'
        | 'updatedAt'
        | 'deletedAt'
        | 'workspace'
        | 'createdBy'
      >
    >;
    relations?: FindOptionsRelations<TaskEntity>;
  }): Promise<Nullable<TaskEntity>> {
    await this.repo.update(id, data);

    const newEntity = await this.findById({
      id,
      relations,
    });

    return newEntity;
  }

  private get transactionalTaskRepo(): Repository<TaskEntity> {
    return this.transactionalRepository.getRepository(TaskEntity);
  }
}
