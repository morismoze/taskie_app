import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { TransactionalRepository } from 'src/modules/unit-of-work/persistence/transactional.repository';
import { SortBy } from 'src/modules/workspace/workspace-module/dto/request/workspace-objective-request-query.dto';
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

  private get repositoryContext(): Repository<TaskEntity> {
    const transactional =
      this.transactionalRepository.getRepository(TaskEntity);

    // If there is a transactional repo available (a transaction bound to the
    // request is available), use it. Otherwise, use normal repo.
    return transactional || this.repo;
  }

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
    const persistenceModel = this.repositoryContext.create({
      workspace: {
        id: workspaceId,
      },
      title: data.title,
      description: data.description,
      rewardPoints: data.rewardPoints,
      dueDate: data.dueDate,
      createdBy: { id: createdById },
    });

    const savedEntity = await this.repositoryContext.save(persistenceModel);

    const newEntity = await this.repositoryContext.findOne({
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
    return await this.repositoryContext.findOne({
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
    return await this.repositoryContext.findOne({
      where: { id: taskId, workspace: { id: workspaceId } },
      relations,
    });
  }

  async findAllByWorkspaceId({
    workspaceId,
    query: { page, limit, status, sort },
  }: {
    workspaceId: string;
    query: {
      page: number;
      limit: number;
      status: ProgressStatus | null;
      sort: SortBy;
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
    const baseQb = this.repositoryContext
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

    // Not yet fully, secure-wise implemented on the DB
    // if (search) {
    //   // Escape special characters used in SQL LIKE/ILIKE
    //   // 1. Escape backslash first
    //   // 2. Escape percent sign
    //   // 3. Escape underscore
    //   // E.g. ILIKE '%%%' - this would return all the goals
    //   // which, if there are many goals, would fill up RAM
    //   // and possibly fail the server.
    //   const sanitizedSearch = search
    //     .replace(/\\/g, '\\\\')
    //     .replace(/%/g, '\\%')
    //     .replace(/_/g, '\\_');

    //   baseQb.andWhere('LOWER(task.title) LIKE :search', {
    //     search: `%${sanitizedSearch.toLowerCase()}%`,
    //   });
    // }

    switch (sort) {
      case SortBy.NEWEST:
        baseQb.orderBy('task.createdAt', 'DESC');
        break;
      case SortBy.OLDEST:
        baseQb.orderBy('task.createdAt', 'ASC');
        break;
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
    const data = await this.repositoryContext
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
    const result = await this.repositoryContext.update(id, data);

    // Early return - provided ID does not exist
    if (result.affected === 0) {
      return null;
    }

    const newEntity = await this.findById({
      id,
      relations,
    });

    return newEntity;
  }
}
