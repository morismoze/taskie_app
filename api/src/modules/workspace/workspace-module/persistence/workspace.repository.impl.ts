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

  async create(
    data: Pick<Workspace, 'name' | 'description' | 'pictureUrl' | 'ownedBy'>,
  ): Promise<Nullable<Workspace>> {
    // goals, standaloneTasks, members are reverse-side relations and not handled here
    const savedEntity = await this.repo.save(data);

    const newEntity = await this.findById(savedEntity.id);

    return newEntity;
  }

  async findById(id: Workspace['id']): Promise<Nullable<Workspace>> {
    const entity = await this.repo.findOne({
      where: { id },
      relations: ['ownedBy', 'goals', 'members', 'standaloneTasks'],
    });

    return entity ? WorkspaceMapper.toDomain(entity) : null;
  }

  async findAllByUserId(
    userId: WorkspaceUser['user']['id'],
  ): Promise<Workspace[]> {
    const entities = await this.repo
      .createQueryBuilder('workspace')
      .innerJoin('workspace.members', 'workspaceUser')
      .leftJoinAndSelect('workspace.ownedBy', 'ownedBy')
      .leftJoinAndSelect('workspace.goals', 'goals')
      .leftJoinAndSelect('workspace.members', 'members')
      .leftJoinAndSelect('workspace.standaloneTasks', 'standaloneTasks')
      .where('workspaceUser.userId = :userId', { userId })
      .getMany(); // always returns array

    return entities.map((entity) => WorkspaceMapper.toDomain(entity));
  }
}
