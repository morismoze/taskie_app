import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations } from 'typeorm';
import { ProgressStatus } from '../domain/progress-status.enum';
import { Task } from '../domain/task.domain';
import { TaskEntity } from './task.entity';

export abstract class TaskRepository {
  abstract create({
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
  }): Promise<Nullable<TaskEntity>>;

  abstract findById({
    id,
    relations,
  }: {
    id: Task['id'];
    relations?: FindOptionsRelations<TaskEntity>;
  }): Promise<Nullable<TaskEntity>>;

  abstract findAllByWorkspaceId({
    workspaceId,
    query: { page, limit, status, search },
    relations,
  }: {
    workspaceId: Task['workspace']['id'];
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
  }>;
}
