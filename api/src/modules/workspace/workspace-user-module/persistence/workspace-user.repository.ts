import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations } from 'typeorm';
import { WorkspaceUserCore } from '../domain/workspace-user-core.domain';
import { WorkspaceUser } from '../domain/workspace-user.domain';
import { WorkspaceUserEntity } from './workspace-user.entity';

export abstract class WorkspaceUserRepository {
  abstract findByIdAndWorkspaceId(args: {
    id: WorkspaceUser['id'];
    workspaceId: WorkspaceUser['workspace']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>>;

  abstract findByUserIdAndWorkspaceId(args: {
    userId: WorkspaceUser['user']['id'];
    workspaceId: WorkspaceUser['workspace']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>>;

  abstract findByIdsAndWorkspaceId(args: {
    ids: Array<WorkspaceUser['user']['id']>;
    workspaceId: WorkspaceUser['workspace']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Array<WorkspaceUserEntity>>;

  abstract findAllByUserId(args: {
    userId: WorkspaceUser['user']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<WorkspaceUserEntity[]>;

  abstract findAllByIds(args: {
    workspaceId: WorkspaceUser['workspace']['id'];
    ids: WorkspaceUser['id'][];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<WorkspaceUserEntity[]>;

  abstract findAllByWorkspaceId(args: {
    workspaceId: WorkspaceUser['workspace']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<WorkspaceUserEntity[]>;

  abstract countManagersInWorkspace(
    workspaceId: WorkspaceUser['workspace']['id'],
  ): Promise<number>;

  abstract create(args: {
    data: {
      workspaceId: WorkspaceUser['workspace']['id'];
      createdById: WorkspaceUser['id'] | null;
      userId: WorkspaceUser['user']['id'];
      workspaceRole: WorkspaceUser['workspaceRole'];
    };
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>>;

  abstract update(args: {
    id: WorkspaceUser['id'];
    data: Partial<WorkspaceUserCore>;
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>>;

  abstract delete(args: {
    workspaceId: WorkspaceUser['workspace']['id'];
    workspaceUserId: WorkspaceUser['user']['id'];
  }): Promise<boolean>;

  abstract getWorkspaceLeaderboard(
    workspaceId: WorkspaceUser['workspace']['id'],
  ): Promise<Array<WorkspaceUserAccumulatedPoints>>;
}

export interface WorkspaceUserAccumulatedPoints {
  id: string;
  firstName: string;
  lastName: string;
  profileImageUrl: string | null;
  accumulatedPoints: number;
  completedTasks: number;
}
