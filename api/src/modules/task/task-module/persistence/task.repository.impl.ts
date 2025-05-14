import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { TransactionalRepository } from 'src/modules/unit-of-work/persistence/transactional.repository';
import {
  FindManyOptions,
  FindOptionsRelations,
  ILike,
  Repository,
} from 'typeorm';
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
    const persistenceModel = this.transactionalTaskRepo.create({
      workspace: {
        id: workspaceId,
      },
      title: data.title,
      description: data.description,
      rewardPoints: data.rewardPoints,
      dueDate: data.dueDate,
      createdBy: { id: createdById },
    });

    const savedEntity = await this.repo.save(persistenceModel);

    const newEntity = await this.findById({
      id: savedEntity.id,
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

  async findAllByWorkspaceId({
    workspaceId,
    query: { page, limit, status, search },
    relations,
  }: {
    workspaceId: string;
    query: {
      page: number;
      limit: number;
      status: ProgressStatus;
      search: string | null;
    };
    relations?: FindOptionsRelations<TaskEntity>;
  }): Promise<{
    data: TaskEntity[];
    total: number;
  }> {
    const offset = (page - 1) * limit;

    const findOptions: FindManyOptions<TaskEntity> = {
      where: { workspace: { id: workspaceId }, taskAssignments: { status } },
      skip: offset,
      take: limit,
      relations: {
        taskAssignments: true, // This is used for fetching status of the task
        ...relations,
      },
    };

    if (search) {
      findOptions.where = {
        ...findOptions.where,
        title: ILike(`%${search}%`),
      };
    }

    const [taskEntities, totalCount] =
      await this.repo.findAndCount(findOptions);

    return {
      data: taskEntities,
      total: totalCount,
    };
  }

  private get transactionalTaskRepo(): Repository<TaskEntity> {
    return this.transactionalRepository.getRepository(TaskEntity);
  }
}
