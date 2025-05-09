import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { FindOptionsRelations } from 'typeorm';
import { GoalEntity } from './goal.entity';

export abstract class GoalRepository {
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
    relations?: FindOptionsRelations<GoalEntity>;
  }): Promise<{
    data: GoalEntity[];
    total: number;
  }>;
}
