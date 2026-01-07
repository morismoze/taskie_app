import { Nullable } from 'src/common/types/nullable.type';
import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceUser } from 'src/modules/workspace/workspace-user-module/domain/workspace-user.domain';
import { FindOptionsRelations } from 'typeorm';
import { WorkspaceInvite } from '../../domain/workspace-invite.domain';
import { WorkspaceInviteEntity } from '../workspace-invite.entity';

/**
 * We use WorkspaceInviteRepository in CRON service which needs classic single instance
 * (singleton) provider. Because of that, WorkspaceInviteRepository can't use TransactionalRepository
 * because that provider is request scoped, meaning it is defined on each HTTP request - so
 * it exists only within the lifecycle of each HTTP request. CRON services are run outside of
 * HTTP request scope, so they can't have a provider which directly or transitively depends
 * on the request scoped provider. And because of all that we create another WorkspaceInviteRepository
 * specifically to be transactional.
 */

export abstract class TransactionalWorkspaceInviteRepository {
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

  abstract markUsedBy({
    id,
    usedById,
    relations,
  }: {
    id: WorkspaceInvite['id'];
    usedById: User['id'];
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>>;
}
