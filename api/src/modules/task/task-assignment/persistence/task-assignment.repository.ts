import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations } from 'typeorm';
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

  abstract findyAllByAssigneeIdAndWorkspaceIdAndStatus({
    workspaceUserId,
    workspaceId,
    status,
  }: {
    workspaceUserId: TaskAssignment['assignee']['id'];
    workspaceId: TaskAssignment['task']['workspace']['id'];
    status: TaskAssignment['status'];
  }): Promise<TaskAssignmentEntity[]>;
}
