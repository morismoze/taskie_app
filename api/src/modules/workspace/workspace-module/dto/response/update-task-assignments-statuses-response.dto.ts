import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export interface UpdateTaskAssignmentStatusResponse {
  assigneeId: string;
  status: ProgressStatus;
}

export type UpdateTaskAssignmentsStatusesResponse =
  UpdateTaskAssignmentStatusResponse[];
