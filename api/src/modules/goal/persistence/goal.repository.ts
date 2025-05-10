import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { FindOptionsRelations } from 'typeorm';
import { Goal } from '../domain/goal.domain';
import { GoalEntity } from './goal.entity';

export abstract class GoalRepository {
  abstract findAllByWorkspaceId({
    workspaceId,
    query: { page, limit, status, search },
    relations,
  }: {
    workspaceId: Goal['workspace']['id'];
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
