import { Injectable, Scope } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { TransactionalRepository } from 'src/modules/unit-of-work/persistence/transactional.repository';
import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceUser } from 'src/modules/workspace/workspace-user-module/domain/workspace-user.domain';
import { FindOptionsRelations, IsNull, Repository } from 'typeorm';
import { WorkspaceInvite } from '../../domain/workspace-invite.domain';
import { WorkspaceInviteEntity } from '../workspace-invite.entity';
import { TransactionalWorkspaceInviteRepository } from './transactional-workspace-invite.repository';

@Injectable({ scope: Scope.REQUEST })
export class TransactionalWorkspaceInviteRepositoryImpl
  implements TransactionalWorkspaceInviteRepository
{
  constructor(
    @InjectRepository(WorkspaceInviteEntity)
    private readonly repo: Repository<WorkspaceInviteEntity>,
    private readonly transactionalRepository: TransactionalRepository,
  ) {}

  private get repositoryContext(): Repository<WorkspaceInviteEntity> {
    const transactional = this.transactionalRepository.getRepository(
      WorkspaceInviteEntity,
    );

    // If there is a transactional repo available (a transaction bound to the
    // request is available), use it. Otherwise, use normal repo.
    return transactional || this.repo;
  }

  async create({
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
  }): Promise<Nullable<WorkspaceInviteEntity>> {
    const persistenceModel = this.repositoryContext.create({
      token,
      workspace: { id: workspaceId },
      createdBy: { id: createdById },
      expiresAt,
    });

    const savedEntity = await this.repositoryContext.save(persistenceModel);

    const newEntity = await this.findById({
      id: savedEntity.id,
      relations,
    });

    return newEntity;
  }

  findById({
    id,
    relations,
  }: {
    id: WorkspaceInvite['id'];
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>> {
    return this.repositoryContext.findOne({
      where: { id },
      relations,
    });
  }

  findByToken({
    token,
    relations,
  }: {
    token: WorkspaceInvite['token'];
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>> {
    return this.repositoryContext.findOne({
      where: { token },
      relations,
    });
  }

  async markUsedBy({
    id,
    usedById,
    relations,
  }: {
    id: WorkspaceInvite['id'];
    usedById: User['id'];
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>> {
    const result = await this.repositoryContext.update(
      {
        id: id,
        // Race condition - if it was already marked as used
        usedBy: IsNull(),
      },
      {
        usedBy: { id: usedById },
      },
    );

    // Early return - provided ID does not exist
    if (result.affected === 0) {
      return null;
    }

    const newEntity = await this.repositoryContext.findOne({
      where: { id },
      relations,
    });

    return newEntity;
  }
}
