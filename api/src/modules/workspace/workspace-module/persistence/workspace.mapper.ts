import { UserMapper } from 'src/modules/user/persistence/user.mapper';
import { Workspace } from '../domain/workspace.domain';
import { WorkspaceEntity } from './workspace.entity';

export class WorkspaceMapper {
  static toDomain(entity: WorkspaceEntity): Workspace {
    return {
      id: entity.id,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      ownedBy: UserMapper.toDomain(entity.ownedBy),
      goals: entity.goals.map(GoalMapper.toDomain),
      members: entity.members.map(WorkspaceUserMapper.toDomain),
      name: entity.name,
      description: entity.description,
      pictureUrl: entity.pictureUrl,
      standaloneTasks: entity.standaloneTasks.map(TaskMapper.toDomain),
    };
  }

  static toPersistence(domain: Workspace): WorkspaceEntity {
    const entity = new WorkspaceEntity();

    entity.id = domain.id;
    entity.createdAt = domain.createdAt;
    entity.updatedAt = domain.updatedAt;
    entity.deletedAt = domain.deletedAt;
    entity.ownedBy = UserMapper.toPersistence(domain.ownedBy);
    entity.goals = domain.goals.map(GoalMapper.toPersistence);
    entity.members = domain.members.map(WorkspaceUserMapper.toPersistence);
    entity.name = domain.name;
    entity.description = domain.description;
    entity.pictureUrl = domain.pictureUrl;
    entity.standaloneTasks = domain.standaloneTasks.map(
      TaskMapper.toPersistence,
    );

    return entity;
  }
}
