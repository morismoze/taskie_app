import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { WorkspaceUserRole } from '../domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from '../domain/workspace-user-status.enum';
import { WorkspaceUser } from '../domain/workspace-user.domain';
import { WorkspaceUserEntity } from './workspace-user.entity';
import { WorkspaceUserMapper } from './workspace-user.mapper';

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
        'workspace.name',
        'workspaceUser.workspaceRole',
        'owner.id',
      ])
      .innerJoin('workspaceUser.user', 'user')
      .innerJoin('workspaceUser.workspace', 'workspace')
      .where('user.id = :userId', { userId })
      .getMany(); // always returns array

    return entities.map((entity) => WorkspaceUserMapper.toDomain(entity));
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

    // We need to fetch newly saved workspace user because TypeORM does not
    // automatically populate relations like user and workspace on save() function
    const newEntity = await this.repo.findOne({
      where: { id: savedEntity.id },
      relations: ['user', 'workspace'],
    });

    return WorkspaceUserMapper.toDomain(newEntity);
  }
}
