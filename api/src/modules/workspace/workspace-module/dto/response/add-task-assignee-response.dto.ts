import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { WorkspaceUserResponse } from './workspace-users-response.dto';

export type AddTaskAssigneeResponse = Array<
  WorkspaceUserResponse & {
    status: ProgressStatus;
  }
>;
