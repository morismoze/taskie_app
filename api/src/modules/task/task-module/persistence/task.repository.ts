import { FindOptionsRelations } from 'typeorm';
import { ProgressStatus } from '../domain/progress-status.enum';
import { TaskEntity } from './task.entity';

export abstract class TaskRepository {
  abstract findAllByWorkspaceId({
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
  }>;
}
