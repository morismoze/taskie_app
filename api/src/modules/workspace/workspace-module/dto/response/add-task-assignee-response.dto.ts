import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { WorkspaceUserResponse } from './workspace-users-response.dto';

export interface AddTaskAssigneeResponse extends WorkspaceUserResponse {
  status: ProgressStatus;
}
