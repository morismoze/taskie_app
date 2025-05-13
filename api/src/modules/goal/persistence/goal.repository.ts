import { Nullable } from 'src/common/types/nullable.type';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
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
    createdById: Goal['createdBy']['id'];
    relations?: FindOptionsRelations<GoalEntity>;
  }): Promise<Nullable<GoalEntity>>;

  abstract findById({
    id,
    relations,
  }: {
    id: Goal['id'];
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
}
