import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { WorkspaceUserRole } from '../domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from '../domain/workspace-user-status.enum';
import { WorkspaceUser } from '../domain/workspace-user.domain';
import { WorkspaceUserEntity } from './workspace-user.entity';

@Injectable()
export class WorkspaceUserRepository {
  constructor(
    @InjectRepository(WorkspaceUserEntity)
    private readonly repo: Repository<WorkspaceUserEntity>,
  ) {}

  async findAllByUserId(
    userId: WorkspaceUser['user']['id'],
  ): Promise<WorkspaceUser[]> {
    const entities = await this.repo
      .createQueryBuilder('workspaceUser')
      .select([
        'workspaceUser.id',
        'workspaceUser.createdAt',
        'user.id',
        'workspace.id',
        'workspaceUser.workspaceRole',
        'owner.id',
      ])
      .innerJoin('workspaceUser.user', 'user')
      .innerJoin('workspaceUser.workspace', 'workspace')
      .innerJoin('workspace.owner', 'owner')
      .where('user.id = :userId', { userId })
      .getMany(); // always returns array

    return entities.map((entity) => this.toDomain(entity));
  }

  async create(
    userId: WorkspaceUser['user']['id'],
    workspaceId: WorkspaceUser['workspace']['id'],
    workspaceRole: WorkspaceUserRole,
    status: WorkspaceUserStatus,
  ): Promise<WorkspaceUser> {
    const entity = this.repo.create({
      user: { id: userId },
      workspace: { id: workspaceId },
      workspaceRole,
      status,
    });

    const savedEntity = await this.repo.save(entity);

    return this.toDomain(savedEntity);
  }

  toDomain(entity: WorkspaceUserEntity): WorkspaceUser {
    return {
      id: entity.id,
      createdAt: entity.createdAt,
      userId: entity.user.id,
      workspaceId: entity.workspace.id,
      workspaceName: entity.workspace.name,
      role: entity.workspaceRole,
      isOwner: entity.workspace.owner.id === entity.user.id,
      status: entity.status,
    };
  }
}
