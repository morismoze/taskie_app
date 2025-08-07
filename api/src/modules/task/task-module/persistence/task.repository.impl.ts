import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { TransactionalRepository } from 'src/modules/unit-of-work/persistence/transactional.repository';
import { SortBy } from 'src/modules/workspace/workspace-module/dto/request/workspace-item-request.dto';
import { FindOptionsRelations, Repository } from 'typeorm';
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
    const offset = (page - 1) * limit;

    const qb = this.repo
      .createQueryBuilder('task')
      .leftJoinAndSelect('task.taskAssignments', 'assignment')
      .leftJoinAndSelect('assignment.assignee', 'assignee')
      .leftJoinAndSelect('assignee.user', 'user')
      .leftJoinAndSelect('task.createdBy', 'createdBy')
      .leftJoinAndSelect('createdBy.user', 'createdByUser')
      .where('task.workspace.id = :workspaceId', { workspaceId });

    if (status) {
      qb.andWhere('assignment.status = :status', { status });
    }

    if (search) {
      qb.andWhere('LOWER(task.title) LIKE :search', {
        search: `%${search.toLowerCase()}%`,
      });
    }

    if (sort) {
      switch (sort) {
        case SortBy.NEWEST:
          qb.orderBy('task.createdAt', 'DESC');
          break;
        case SortBy.OLDEST:
          qb.orderBy('task.createdAt', 'ASC');
          break;
      }
    }

    qb.skip(offset).take(limit);

    const [taskEntities, totalCount] = await qb.getManyAndCount();

    return {
      data: taskEntities,
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
