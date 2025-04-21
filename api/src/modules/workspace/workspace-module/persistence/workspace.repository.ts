import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { Repository } from 'typeorm';
import { WorkspaceUser } from '../../workspace-user-module/domain/workspace-user.domain';
import { WorkspaceUserMapper } from '../../workspace-user-module/persistence/workspace-user.mapper';
import { Workspace } from '../domain/workspace.domain';
import { WorkspaceEntity } from './workspace.entity';

@Injectable()
export class WorkspaceRepository {
  constructor(
    @InjectRepository(WorkspaceEntity)
    private readonly repo: Repository<WorkspaceEntity>,
  ) {}

  async create(
    data: Pick<Workspace, 'name' | 'description'>,
    ownerId: Workspace['ownedBy']['id'],
  ): Promise<Workspace> {
    // members and goals
    const entity = this.repo.create({
      name: data.name,
      description: data.description,
      ownedBy: { id: ownerId },
    });
    const newUser = await this.repo.save(entity);

    return this.toDomain(newUser);
  }

  async findById(id: Workspace['id']): Promise<Nullable<Workspace>> {
    const entity = await this.repo.findOne({
      where: { id },
      relations: {
        goals: true,
        members: true,
        standaloneTasks: true,
      },
    });

    return entity ? this.toDomain(entity) : null;
  }

  async findAllByUserId(
    userId: WorkspaceUser['user']['id'],
  ): Promise<Nullable<Workspace[]>> {
    const entities = await this.repo
      .createQueryBuilder('workspace')
      .innerJoin('workspace.members', 'workspaceUser')
      .where('workspaceUser.userId = :userId', { userId })
      .getMany(); // always returns array

    return entities.map((entity) => this.toDomain(entity));
  }

  private toDomain(entity: WorkspaceEntity): Workspace {
    return {
      id: entity.id,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      name: entity.name,
      ownedBy: {
        id: entity.ownedBy.id,
      },
      goals: entity.goals.map((goal) => ({
        id: goal.id,
      })),
      members: entity.members.map((member) =>
        WorkspaceUserMapper.toDomain(member),
      ),
      standaloneTasks: entity.standaloneTasks.map((task) => ({
        id: task.id,
      })),
      description: entity.description,
      pictureUrl: entity.pictureUrl,
    };
  }
}
