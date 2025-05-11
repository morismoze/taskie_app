import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations } from 'typeorm';
import { WorkspaceInviteStatus } from '../domain/workspace-invite-status.enum';
import { WorkspaceInvite } from '../domain/workspace-invite.domain';
import { WorkspaceInviteEntity } from './workspace-invite.entity';

export abstract class WorkspaceInviteRepository {
  abstract create({
    data: { token, workspaceId, createdById, expiresAt, status },
    relations,
  }: {
    data: {
      token: WorkspaceInvite['token'];
      workspaceId: WorkspaceInvite['workspace']['id'];
      createdById: WorkspaceInvite['createdBy']['id'];
      expiresAt: Date;
      status: WorkspaceInviteStatus;
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

  abstract update({
    id,
    data,
    relations,
  }: {
    id: WorkspaceInvite['id'];
    data: Partial<
      Omit<WorkspaceInvite, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>
    >;
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>>;
}
