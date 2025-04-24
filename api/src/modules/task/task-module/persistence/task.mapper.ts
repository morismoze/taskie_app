import { WorkspaceMapper } from 'src/modules/workspace/workspace-module/persistence/workspace.mapper';
import { WorkspaceUserMapper } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.mapper';
import { GoalMapper } from '../../goal-module/persistence/goal.mapper';
import { Task } from '../domain/task.domain';
import { TaskEntity } from './task.entity';

export class TaskMapper {
  static toDomain(entity: TaskEntity): Task {
    return {
      id: entity.id,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      assignees: entity.assignees.map(WorkspaceUserMapper.toDomain),
      createdBy: WorkspaceUserMapper.toDomain(entity.createdBy),
      description: entity.description,
      reward: entity.reward,
      goal: entity.goal ? GoalMapper.toDomain(entity.goal) : null,
      rewardPoints: entity.rewardPoints,
      status: entity.status,
      title: entity.title,
      workspace: WorkspaceMapper.toDomain(entity.workspace),
    };
  }

  static toPersistence(domain: Task): TaskEntity {
    const entity = new TaskEntity();

    entity.id = domain.id;
    entity.createdAt = domain.createdAt;
    entity.updatedAt = domain.updatedAt;
    entity.deletedAt = domain.deletedAt;
    entity.assignees = domain.assignees.map(WorkspaceUserMapper.toPersistence);
    entity.createdBy = WorkspaceUserMapper.toPersistence(domain.createdBy);
    entity.description = domain.description;
    entity.reward = domain.reward;
    entity.goal = domain.goal ? GoalMapper.toPersistence(domain.goal) : null;
    entity.rewardPoints = domain.rewardPoints;
    entity.status = domain.status;
    entity.title = domain.title;
    entity.workspace = WorkspaceMapper.toPersistence(domain.workspace);

    return entity;
  }
}
