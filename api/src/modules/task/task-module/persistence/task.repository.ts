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

  abstract findByTaskIdAndWorkspaceId({
    taskId,
    workspaceId,
    relations,
  }: {
    taskId: Task['id'];
    workspaceId: Task['workspace']['id'];
    relations?: FindOptionsRelations<TaskEntity>;
  }): Promise<Nullable<TaskEntity>>;

  abstract findAllByWorkspaceId({
    workspaceId,
    query: { page, limit, status, search },
  }: {
    workspaceId: Task['workspace']['id'];
    query: {
      page: number;
      limit: number;
      status: ProgressStatus;
      search: string | null;
    };
  }): Promise<{
    data: TaskEntity[];
    total: number;
  }>;

  abstract update({
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
  }): Promise<Nullable<TaskEntity>>;
}
