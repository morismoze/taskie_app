import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { Repository } from 'typeorm';
import { WorkspaceUser } from '../domain/workspace-user.domain';
import { WorkspaceUserEntity } from './workspace-user.entity';
import { WorkspaceUserMapper } from './workspace-user.mapper';
import { WorkspaceUserRepository } from './workspace-user.repository';

@Injectable()
export class WorkspaceUserRepositoryImpl implements WorkspaceUserRepository {
  constructor(
    @InjectRepository(WorkspaceUserEntity)
    private readonly repo: Repository<WorkspaceUserEntity>,
  ) {}

  async findByUserId(
    userId: WorkspaceUser['user']['id'],
  ): Promise<Nullable<WorkspaceUser>> {
    const user = await this.repo.findOne({
      where: { user: { id: userId } },
      relations: ['workspace', 'user', 'createdBy'],
    });

    return user ? WorkspaceUserMapper.toDomain(user) : null;
  }

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

  async create(data: WorkspaceUser): Promise<Nullable<WorkspaceUser>> {
    const persistenceModel = WorkspaceUserMapper.toPersistence(data);

    const savedEntity = await this.repo.save(persistenceModel);

    const newEntity = await this.findByUserId(savedEntity.user.id);

    return newEntity;
  }
}
