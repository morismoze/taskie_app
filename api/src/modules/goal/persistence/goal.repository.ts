import { Nullable } from 'src/common/types/nullable.type';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { WorkspaceUser } from 'src/modules/workspace/workspace-user-module/domain/workspace-user.domain';
import { FindOptionsRelations } from 'typeorm';
import { Goal } from '../domain/goal.domain';
import { GoalEntity } from './goal.entity';

export abstract class GoalRepository {
  abstract create({
    data,
    workspaceId,
    createdById,
    relations,
  }: {
    data: {
      title: Goal['title'];
      description: Goal['description'];
      requiredPoints: Goal['requiredPoints'];
      assigneeId: Goal['assignee']['id'];
    };
    workspaceId: Goal['workspace']['id'];
    createdById: WorkspaceUser['id'];
    relations?: FindOptionsRelations<GoalEntity>;
  }): Promise<Nullable<GoalEntity>>;

  abstract findById({
    id,
    relations,
  }: {
    id: Goal['id'];
    relations?: FindOptionsRelations<GoalEntity>;
  }): Promise<Nullable<GoalEntity>>;

  abstract findByGoalIdAndWorkspaceId({
    goalId,
    workspaceId,
    relations,
  }: {
    goalId: Goal['id'];
    workspaceId: Goal['workspace']['id'];
    relations?: FindOptionsRelations<GoalEntity>;
  }): Promise<Nullable<GoalEntity>>;

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

  abstract update({
    id,
    data,
  }: {
    id: Goal['id'];
    data: Partial<
      Omit<
        Goal,
        'id' | 'createdAt' | 'updatedAt' | 'deletedAt' | 'assignee'
      > & { assigneeId: Goal['assignee']['id'] }
    >;
    relations?: FindOptionsRelations<GoalEntity>;
  }): Promise<Nullable<GoalEntity>>;
}
