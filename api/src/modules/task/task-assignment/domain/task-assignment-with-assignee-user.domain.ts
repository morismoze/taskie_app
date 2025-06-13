import { WorkspaceUserWithUser } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-with-user.domain';
import { TaskAssignmentCore } from './task-assignment-core.domain';

export interface TaskAssignmentWithAssigneeUser extends TaskAssignmentCore {
  assignee: WorkspaceUserWithUser;
}
