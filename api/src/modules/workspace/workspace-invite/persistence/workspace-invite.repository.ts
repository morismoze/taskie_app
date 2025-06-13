import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations } from 'typeorm';
import { WorkspaceUser } from '../../workspace-user-module/domain/workspace-user.domain';
import { WorkspaceInvite } from '../domain/workspace-invite.domain';
import { WorkspaceInviteEntity } from './workspace-invite.entity';

export abstract class WorkspaceInviteRepository {
  abstract create({
    data: { token, workspaceId, createdById, expiresAt },
    relations,
  }: {
    data: {
      token: WorkspaceInvite['token'];
      workspaceId: WorkspaceInvite['workspace']['id'];
      createdById: WorkspaceUser['id'];
      expiresAt: string;
    };
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>>;

  abstract findByToken({
    token,
    relations,
  }: {
    token: WorkspaceInvite['token'];
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>>;

  abstract findById({
    id,
    relations,
  }: {
    id: WorkspaceInvite['id'];
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>>;

  abstract deleteExpiredInvites(): Promise<void>;
}
