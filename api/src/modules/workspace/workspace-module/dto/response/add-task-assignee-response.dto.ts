import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { WorkspaceUserResponse } from './workspace-users-response.dto';

// Array is returned because all the newly added assignees are returned
export type AddTaskAssigneeResponse = Array<
  WorkspaceUserResponse & {
    status: ProgressStatus;
  }
>;
