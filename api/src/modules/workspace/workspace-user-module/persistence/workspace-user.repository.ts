import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations } from 'typeorm';
import { WorkspaceUserCore } from '../domain/workspace-user-core.domain';
import { WorkspaceUser } from '../domain/workspace-user.domain';
import { WorkspaceUserEntity } from './workspace-user.entity';

export abstract class WorkspaceUserRepository {
  abstract findById({
    id,
    relations,
  }: {
    id: WorkspaceUser['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>>;

  abstract findByUserIdAndWorkspaceId({
    userId,
    workspaceId,
    relations,
  }: {
    userId: WorkspaceUser['user']['id'];
    workspaceId: WorkspaceUser['workspace']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>>;

  abstract findAllByUserId({
    userId,
    relations,
  }: {
    userId: WorkspaceUser['user']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<WorkspaceUserEntity[]>;

  abstract findAllByIds({
    workspaceId,
    ids,
    relations,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    ids: WorkspaceUser['id'][];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<WorkspaceUserEntity[]>;

  abstract create({
    data,
    relations,
  }: {
    data: {
      workspaceId: WorkspaceUser['workspace']['id'];
      createdById: WorkspaceUser['id'] | null;
      userId: WorkspaceUser['user']['id'];
      workspaceRole: WorkspaceUser['workspaceRole'];
      status: WorkspaceUser['status'];
    };
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>>;

  abstract update({
    id,
    data,
    relations,
  }: {
    id: WorkspaceUser['id'];
    data: Partial<WorkspaceUserCore>;
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>>;

  abstract delete({
    workspaceId,
    workspaceUserId,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    workspaceUserId: WorkspaceUser['user']['id'];
  }): Promise<void>;

  abstract getWorkspaceUserAccumulatedPoints({
    workspaceId,
    workspaceUserId,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    workspaceUserId;
  }): Promise<Nullable<number>>;

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
