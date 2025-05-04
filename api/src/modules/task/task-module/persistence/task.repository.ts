import { ProgressStatus } from '../domain/progress-status.enum';
import { TaskEntity } from './task.entity';

export abstract class TaskRepository {
  abstract findTasksWithAssigneesForWorkspace(
    workspaceId: string,
    {
      page,
      limit,
      status,
      search,
    }: {
      page: number;
      limit: number;
      status?: ProgressStatus;
      search?: string;
    },
  ): Promise<{ data: TaskEntity[]; total: number }>;
}
