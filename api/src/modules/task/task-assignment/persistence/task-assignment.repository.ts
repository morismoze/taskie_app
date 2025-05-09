import { ProgressStatus } from '../../task-module/domain/progress-status.enum';
import { TaskAssignmentEntity } from './task-assignment.entity';

export abstract class TaskAssignmentRepository {
  abstract findyAllByAssigneeIdAndWorkspaceIdAndStatus({
    workspaceUserId,
    workspaceId,
    status,
  }: {
    workspaceUserId: string;
    workspaceId: string;
    status: ProgressStatus;
  }): Promise<TaskAssignmentEntity[]>;
}
