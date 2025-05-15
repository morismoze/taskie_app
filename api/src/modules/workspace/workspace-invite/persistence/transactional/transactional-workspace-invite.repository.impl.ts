import { Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { TransactionalRepository } from 'src/modules/unit-of-work/persistence/transactional.repository';
import { FindOptionsRelations, Repository } from 'typeorm';
import { WorkspaceInviteStatus } from '../../domain/workspace-invite-status.enum';
import { WorkspaceInvite } from '../../domain/workspace-invite.domain';
import { WorkspaceInviteEntity } from '../workspace-invite.entity';
import { WorkspaceInviteRepository } from '../workspace-invite.repository';
import { TransactionalWorkspaceInviteRepository } from './transactional-workspace-invite.repository';

@Injectable()
export class TransactionalWorkspaceInviteRepositoryImpl
  implements TransactionalWorkspaceInviteRepository
{
  constructor(
    private readonly repo: WorkspaceInviteRepository,
    private readonly transactionalRepository: TransactionalRepository,
  ) {}

  async create({
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
  }): Promise<Nullable<WorkspaceInviteEntity>> {
    const persistenceModel = this.transactionalWorkspaceInviteRepo.create({
      token,
      workspace: { id: workspaceId },
      createdBy: { id: createdById },
      expiresAt,
      status,
    });

    const savedEntity =
      await this.transactionalWorkspaceInviteRepo.save(persistenceModel);

    const newEntity = await this.repo.findById({
      id: savedEntity.id,
      relations,
    });

    return newEntity;
  }

  async markUsedBy({
    id,
    usedById,
    relations,
  }: {
    id: WorkspaceInvite['id'];
    usedById: WorkspaceInvite['usedBy']['id'];
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>> {
    this.transactionalWorkspaceInviteRepo.update(id, {
      usedBy: { id: usedById },
      status: WorkspaceInviteStatus.USED,
    });

    const newEntity = await this.repo.findById({ id, relations });

    return newEntity;
  }

  private get transactionalWorkspaceInviteRepo(): Repository<WorkspaceInviteEntity> {
    return this.transactionalRepository.getRepository(WorkspaceInviteEntity);
  }
}
