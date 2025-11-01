import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export interface UpdateTaskAssignmentResponse {
  assigneeId: string;
  status: ProgressStatus;
}

export type UpdateTaskAssignmentsStatusesResponse =
  UpdateTaskAssignmentResponse[];
