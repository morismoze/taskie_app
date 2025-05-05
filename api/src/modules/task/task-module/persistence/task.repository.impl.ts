import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import {
  FindManyOptions,
  FindOptionsRelations,
  ILike,
  Repository,
} from 'typeorm';
import { ProgressStatus } from '../domain/progress-status.enum';
import { TaskEntity } from './task.entity';
import { TaskRepository } from './task.repository';

@Injectable()
export class TaskRepositoryImpl implements TaskRepository {
  constructor(
    @InjectRepository(TaskEntity)
    private readonly repo: Repository<TaskEntity>,
  ) {}

  async findAllByWorkspaceId({
    workspaceId,
    query: { page, limit, status, search },
    relations,
  }: {
    workspaceId: string;
    query: {
      page: number;
      limit: number;
      status?: ProgressStatus;
      search?: string;
    };
    relations?: FindOptionsRelations<TaskEntity>;
  }): Promise<{
    data: TaskEntity[];
    total: number;
  }> {
    const offset = (page - 1) * limit;

    const findOptions: FindManyOptions<TaskEntity> = {
      where: { workspace: { id: workspaceId } },
      skip: offset,
      take: limit,
      relations: {
        taskAssignments: true, // This is used for fetching status of the task
        ...relations,
      },
    };

    if (status) {
      findOptions.where = {
        ...findOptions.where,
        taskAssignments: { status },
      };
    }

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
}
