import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations, Repository } from 'typeorm';
import { WorkspaceUser } from '../domain/workspace-user.domain';
import { WorkspaceUserEntity } from './workspace-user.entity';
import { WorkspaceUserRepository } from './workspace-user.repository';

@Injectable()
export class WorkspaceUserRepositoryImpl implements WorkspaceUserRepository {
  constructor(
    @InjectRepository(WorkspaceUserEntity)
    private readonly repo: Repository<WorkspaceUserEntity>,
  ) {}

  async findByUserId({
    userId,
    relations,
  }: {
    userId: WorkspaceUser['user']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>> {
    return await this.repo.findOne({
      where: { user: { id: userId } },
      relations,
    });
  }

  async findAllByUserId({
    userId,
    relations,
  }: {
    userId: WorkspaceUser['user']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<WorkspaceUserEntity[]> {
    return await this.repo.find({
      where: {
        user: {
          id: userId,
        },
      },
      relations,
    });
  }

  async create({
    data: { workspaceId, userId, workspaceRole, status },
    createdById,
    relations,
  }: {
    data: {
      workspaceId: WorkspaceUser['workspace']['id'];
      userId: WorkspaceUser['user']['id'];
      workspaceRole: WorkspaceUser['workspaceRole'];
      status: WorkspaceUser['status'];
    };
    createdById: WorkspaceUser['id'] | null;
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>> {
    const persistenceModel = this.repo.create({
      workspace: { id: workspaceId },
      user: { id: userId },
      workspaceRole,
      status,
      createdBy: createdById ? { id: createdById } : null,
    });

    const savedEntity = await this.repo.save(persistenceModel);

    const newEntity = await this.findByUserId({
      userId: savedEntity.user.id,
      relations,
    });

    return newEntity;
  }
}
