import { Nullable } from 'src/common/types/nullable.type';
import { User } from 'src/modules/user/domain/user.domain';
import { FindOptionsRelations } from 'typeorm';
import { WorkspaceInvite } from '../../domain/workspace-invite.domain';
import { WorkspaceInviteEntity } from '../workspace-invite.entity';

export abstract class TransactionalWorkspaceInviteRepository {
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
