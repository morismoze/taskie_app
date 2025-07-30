import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DateTime } from 'luxon';
import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations, LessThan, Repository } from 'typeorm';
import { WorkspaceUser } from '../../workspace-user-module/domain/workspace-user.domain';
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
    const persistenceModel = this.repo.create({
      token,
      workspace: { id: workspaceId },
      createdBy: { id: createdById },
      expiresAt,
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

  async deleteExpiredInvites(): Promise<void> {
    const now = DateTime.now().toJSDate();
    await this.repo.delete({
      expiresAt: LessThan(now),
    });
  }
}
