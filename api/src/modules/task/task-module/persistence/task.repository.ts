import { Nullable } from 'src/common/types/nullable.type';
import { SortBy } from 'src/modules/workspace/workspace-module/dto/request/workspace-objective-request-query.dto';
import { FindOptionsRelations } from 'typeorm';
import { ProgressStatus } from '../domain/progress-status.enum';
import { Task } from '../domain/task.domain';
import { TaskEntity } from './task.entity';

export abstract class TaskRepository {
  abstract create(args: {
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

  abstract findById(args: {
    id: Task['id'];
    relations?: FindOptionsRelations<TaskEntity>;
  }): Promise<Nullable<TaskEntity>>;

  abstract findByTaskIdAndWorkspaceId(args: {
    taskId: Task['id'];
    workspaceId: Task['workspace']['id'];
    relations?: FindOptionsRelations<TaskEntity>;
  }): Promise<Nullable<TaskEntity>>;

  abstract findAllByWorkspaceId(args: {
    workspaceId: Task['workspace']['id'];
    query: {
      page: number;
      limit: number;
      sort: SortBy;
      status: ProgressStatus | null;
    };
  }): Promise<{
    data: TaskEntity[];
    totalPages: number;
    total: number;
  }>;

  abstract update(args: {
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
