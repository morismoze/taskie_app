import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations } from 'typeorm';
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

  abstract findByUserId({
    userId,
    relations,
  }: {
    userId: WorkspaceUser['user']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>>;

  abstract findAllByUserId({
    userId,
    relations,
  }: {
    userId: WorkspaceUser['user']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<WorkspaceUserEntity[]>;

  abstract create({
    data,
    relations,
  }: {
    data: {
      workspaceId: WorkspaceUser['workspace']['id'];
      userId: WorkspaceUser['user']['id'];
      workspaceRole: WorkspaceUser['workspaceRole'];
      status: WorkspaceUser['status'];
    };
    createdById: WorkspaceUser['id'] | null;
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>>;
}
