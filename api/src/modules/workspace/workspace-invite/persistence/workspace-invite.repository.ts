import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations } from 'typeorm';
import { WorkspaceInviteStatus } from '../domain/workspace-invite-status.enum';
import { WorkspaceInvite } from '../domain/workspace-invite.domain';
import { WorkspaceInviteEntity } from './workspace-invite.entity';

export abstract class WorkspaceInviteRepository {
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
