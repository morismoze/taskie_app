import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { Repository } from 'typeorm';
import { WorkspaceUser } from '../../workspace-user-module/domain/workspace-user.domain';
import { Workspace } from '../domain/workspace.domain';
import { WorkspaceEntity } from './workspace.entity';
import { WorkspaceMapper } from './workspace.mapper';
import { WorkspaceRepository } from './workspace.repository';

@Injectable()
export class WorkspaceRepositoryImpl implements WorkspaceRepository {
  constructor(
    @InjectRepository(WorkspaceEntity)
    private readonly repo: Repository<WorkspaceEntity>,
  ) {}

  async create(data: Workspace): Promise<Nullable<Workspace>> {
    const persistenceModel = WorkspaceMapper.toPersistence(data);

    const savedEntity = await this.repo.save(persistenceModel);

    const newEntity = await this.repo.findOne({
      where: { id: savedEntity.id },
      relations: ['user', 'goals', 'members', 'standaloneTasks'],
    });

    return newEntity !== null ? WorkspaceMapper.toDomain(newEntity) : null;
  }

  async findById(id: Workspace['id']): Promise<Nullable<Workspace>> {
    const entity = await this.repo.findOne({
      where: { id },
      relations: ['user', 'goals', 'members', 'standaloneTasks'],
    });

    return entity ? WorkspaceMapper.toDomain(entity) : null;
  }

  async findAllByUserId(
    userId: WorkspaceUser['user']['id'],
  ): Promise<Workspace[]> {
    const entities = await this.repo
      .createQueryBuilder('workspace')
      .innerJoin('workspace.members', 'workspaceUser')
      .where('workspaceUser.userId = :userId', { userId })
      .getMany(); // always returns array

    return entities.map((entity) => WorkspaceMapper.toDomain(entity));
  }
}
