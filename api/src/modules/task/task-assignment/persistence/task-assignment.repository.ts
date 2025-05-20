import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations } from 'typeorm';
import { TaskAssignmentCore } from '../domain/task-assignment-core.domain';
import { TaskAssignment } from '../domain/task-assignment.domain';
import { TaskAssignmentEntity } from './task-assignment.entity';

export abstract class TaskAssignmentRepository {
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

  abstract findByTaskId({
    id,
    relations,
  }: {
    id: TaskAssignment['task']['id'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>>;

  abstract findyAllByAssigneeIdAndWorkspaceIdAndStatus({
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

  abstract deleteByTaskIdAndAssigneeIds({
    taskId,
    assigneeIds,
  }: {
    taskId: TaskAssignment['task']['id'];
    assigneeIds: Array<TaskAssignment['assignee']['id']>;
  }): Promise<void>;
}
