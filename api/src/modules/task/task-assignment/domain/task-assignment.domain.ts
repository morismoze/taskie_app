import { RootDomain } from 'src/modules/database/domain/root.domain';
import { WorkspaceUser } from 'src/modules/workspace/workspace-user-module/domain/workspace-user.domain';
import { ProgressStatus } from '../../task-module/domain/progress-status.enum';
import { Task } from '../../task-module/domain/task.domain';

export interface TaskAssignment extends RootDomain {
  task: Task;
  assignee: WorkspaceUser;
  status: ProgressStatus;
}
