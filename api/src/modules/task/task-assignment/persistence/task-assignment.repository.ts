import { Nullable } from 'src/common/types/nullable.type';
import { Workspace } from 'src/modules/workspace/workspace-module/domain/workspace.domain';
import { FindOptionsRelations } from 'typeorm';
import { TaskAssignmentCore } from '../domain/task-assignment-core.domain';
import { TaskAssignment } from '../domain/task-assignment.domain';
import { TaskAssignmentEntity } from './task-assignment.entity';

export abstract class TaskAssignmentRepository {
  abstract sumPointsByAssignee(args: {
    workspaceUserId: TaskAssignment['assignee']['id'];
    workspaceId: Workspace['id'];
  }): Promise<number>;

  abstract create(args: {
    workspaceUserId: TaskAssignment['assignee']['id'];
    taskId: TaskAssignment['task']['id'];
    status: TaskAssignment['status'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>>;

  abstract createMultiple(args: {
    assignments: Array<{
      workspaceUserId: TaskAssignment['assignee']['id'];
      status: TaskAssignment['status'];
    }>;
    taskId: TaskAssignment['task']['id'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Array<TaskAssignmentEntity>>;

  abstract findById(args: {
    id: TaskAssignment['id'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>>;

  abstract findAllByTaskId(args: {
    taskId: TaskAssignment['task']['id'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<TaskAssignmentEntity[]>;

  abstract findAllByTaskIdAndAssigneeIds(args: {
    taskId: TaskAssignment['task']['id'];
    assigneeIds: Array<TaskAssignment['assignee']['id']>;
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<TaskAssignmentEntity[]>;

  abstract findAllByAssigneeIdAndWorkspaceIdAndStatus(args: {
    workspaceUserId: TaskAssignment['assignee']['id'];
    workspaceId: TaskAssignment['task']['workspace']['id'];
    status: TaskAssignment['status'];
  }): Promise<TaskAssignmentEntity[]>;

  abstract update(args: {
    id: TaskAssignment['id'];
    data: Partial<TaskAssignmentCore>;
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>>;

  abstract updateAllByTaskId(args: {
    taskId: TaskAssignment['task']['id'];
    data: Partial<TaskAssignmentCore>;
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity[]>>;

  abstract countByTaskId(id: TaskAssignment['task']['id']): Promise<number>;

  abstract deleteByTaskIdAndAssigneeIds(args: {
    taskId: TaskAssignment['task']['id'];
    assigneeIds: Array<TaskAssignment['assignee']['id']>;
  }): Promise<boolean>;
}
