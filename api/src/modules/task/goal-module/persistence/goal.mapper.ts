import { WorkspaceMapper } from 'src/modules/workspace/workspace-module/persistence/workspace.mapper';
import { WorkspaceUserMapper } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.mapper';
import { TaskMapper } from '../../task-module/persistence/task.mapper';
import { Goal } from '../domain/goal.domain';
import { GoalEntity } from './goal.entity';

export class GoalMapper {
  static toDomain(entity: GoalEntity): Goal {
    return {
      id: entity.id,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      assignees: entity.assignees.map(WorkspaceUserMapper.toDomain),
      createdBy: WorkspaceUserMapper.toDomain(entity.createdBy),
      description: entity.description,
      requiredPoints: entity.requiredPoints,
      reward: entity.reward,
      status: entity.status,
      tasks: entity.tasks ? entity.tasks.map(TaskMapper.toDomain) : null,
      type: entity.type,
      workspace: WorkspaceMapper.toDomain(entity.workspace),
    };
  }

  static toPersistence(domain: Goal): GoalEntity {
    const entity = new GoalEntity();

    entity.id = domain.id;
    entity.createdAt = domain.createdAt;
    entity.updatedAt = domain.updatedAt;
    entity.deletedAt = domain.deletedAt;
    entity.assignees = domain.assignees.map(WorkspaceUserMapper.toPersistence);
    entity.createdBy = WorkspaceUserMapper.toPersistence(domain.createdBy);
    entity.description = domain.description;
    entity.requiredPoints = domain.requiredPoints;
    entity.reward = domain.reward;
    entity.status = domain.status;
    entity.tasks = domain.tasks
      ? domain.tasks.map(TaskMapper.toPersistence)
      : null;
    entity.type = domain.type;
    entity.workspace = WorkspaceMapper.toPersistence(domain.workspace);

    return entity;
  }
}
