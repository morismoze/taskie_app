import { Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { TransactionalRepository } from 'src/modules/unit-of-work/persistence/transactional.repository';
import { User } from 'src/modules/user/domain/user.domain';
import { FindOptionsRelations, Repository } from 'typeorm';
import { WorkspaceInvite } from '../../domain/workspace-invite.domain';
import { WorkspaceInviteEntity } from '../workspace-invite.entity';
import { TransactionalWorkspaceInviteRepository } from './transactional-workspace-invite.repository';

@Injectable()
export class TransactionalWorkspaceInviteRepositoryImpl
  implements TransactionalWorkspaceInviteRepository
{
  constructor(
    private readonly transactionalRepository: TransactionalRepository,
  ) {}

  async markUsedBy({
    id,
    usedById,
    relations,
  }: {
    id: WorkspaceInvite['id'];
    usedById: User['id'];
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>> {
    await this.transactionalWorkspaceInviteRepo.update(id, {
      usedBy: { id: usedById },
    });

    const newEntity = await this.transactionalWorkspaceInviteRepo.findOne({
      where: { id },
      relations,
    });

    return newEntity;
  }

  private get transactionalWorkspaceInviteRepo(): Repository<WorkspaceInviteEntity> {
    return this.transactionalRepository.getRepository(WorkspaceInviteEntity);
  }
}
