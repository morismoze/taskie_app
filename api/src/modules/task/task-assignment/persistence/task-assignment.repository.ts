import { Nullable } from 'src/common/types/nullable.type';
import { Workspace } from 'src/modules/workspace/workspace-module/domain/workspace.domain';
import { FindOptionsRelations } from 'typeorm';
import { TaskAssignmentCore } from '../domain/task-assignment-core.domain';
import { TaskAssignment } from '../domain/task-assignment.domain';
import { TaskAssignmentEntity } from './task-assignment.entity';

export abstract class TaskAssignmentRepository {
  abstract sumPointsByAssignee({
    workspaceUserId,
    workspaceId,
  }: {
    workspaceUserId: TaskAssignment['assignee']['id'];
    workspaceId: Workspace['id'];
  }): Promise<number>;

  abstract create({
    workspaceUserId,
    taskId,
    status,
    relations,
  }: {
    workspaceUserId: TaskAssignment['assignee']['id'];
    taskId: TaskAssignment['task']['id'];
    status: TaskAssignment['status'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>>;

  abstract createMultiple({
    workspaceUserIds,
    taskId,
    status,
    relations,
  }: {
    workspaceUserIds: Array<TaskAssignment['assignee']['id']>;
    taskId: TaskAssignment['task']['id'];
    status: TaskAssignment['status'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Array<TaskAssignmentEntity>>;

  abstract findById({
    id,
    relations,
  }: {
    id: TaskAssignment['id'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>>;

  abstract findAllByTaskId({
    taskId,
    relations,
  }: {
    taskId: TaskAssignment['task']['id'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<TaskAssignmentEntity[]>;

  abstract findAllByTaskIdAndAssigneeId({
    taskId,
    assigneeIds,
    relations,
  }: {
    taskId: TaskAssignment['task']['id'];
    assigneeIds: Array<TaskAssignment['assignee']['id']>;
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<TaskAssignmentEntity[]>;

  abstract findAllByAssigneeIdAndWorkspaceIdAndStatus({
    workspaceUserId,
    workspaceId,
    status,
  }: {
    workspaceUserId: TaskAssignment['assignee']['id'];
    workspaceId: TaskAssignment['task']['workspace']['id'];
    status: TaskAssignment['status'];
  }): Promise<TaskAssignmentEntity[]>;

  abstract update({
    id,
    data,
    relations,
  }: {
    id: TaskAssignment['id'];
    data: Partial<TaskAssignmentCore>;
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>>;

  abstract updateAllByTaskId({
    taskId,
    data,
    relations,
  }: {
    taskId: TaskAssignment['task']['id'];
    data: Partial<TaskAssignmentCore>;
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity[]>>;

  abstract countByTaskId(id: TaskAssignment['task']['id']): Promise<number>;

  abstract deleteByTaskIdAndAssigneeIds({
    taskId,
    assigneeIds,
  }: {
    taskId: TaskAssignment['task']['id'];
    assigneeIds: Array<TaskAssignment['assignee']['id']>;
  }): Promise<boolean>;
}
