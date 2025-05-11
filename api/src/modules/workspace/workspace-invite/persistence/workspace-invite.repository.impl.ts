import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations, LessThan, Repository } from 'typeorm';
import { WorkspaceInviteStatus } from '../domain/workspace-invite-status.enum';
import { WorkspaceInvite } from '../domain/workspace-invite.domain';
import { WorkspaceInviteEntity } from './workspace-invite.entity';
import { WorkspaceInviteRepository } from './workspace-invite.repository';

@Injectable()
export class WorkspaceInviteRepositoryImpl
  implements WorkspaceInviteRepository
{
  constructor(
    @InjectRepository(WorkspaceInviteEntity)
    private readonly repo: Repository<WorkspaceInviteEntity>,
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
    const persistenceModel = this.repo.create({
      token,
      workspace: { id: workspaceId },
      createdBy: { id: createdById },
      expiresAt,
      status,
    });

    const savedEntity = await this.repo.save(persistenceModel);

    const newEntity = await this.findById({
      id: savedEntity.id,
      relations,
    });

    return newEntity;
  }

  async findById({
    id,
    relations,
  }: {
    id: WorkspaceInvite['id'];
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>> {
    return await this.repo.findOne({
      where: { id },
      relations,
    });
  }

  async findByToken({
    token,
    relations,
  }: {
    token: WorkspaceInvite['token'];
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>> {
    return await this.repo.findOne({
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
    usedById: WorkspaceInvite['usedBy']['id'];
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>> {
    this.repo.update(id, {
      usedBy: { id: usedById },
      status: WorkspaceInviteStatus.USED,
    });

    const newEntity = await this.findById({ id, relations });

    return newEntity;
  }

  async deleteInactiveInvitesBefore(
    cutoffDate: WorkspaceInvite['expiresAt'],
  ): Promise<void> {
    await this.repo.delete({
      updatedAt: LessThan(cutoffDate),
    });
  }
}
