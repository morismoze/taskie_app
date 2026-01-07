import { WorkspaceUserCore } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-core.domain';
import { TaskAssignmentCore } from './task-assignment-core.domain';

export interface TaskAssignmentWithAssignee extends TaskAssignmentCore {
  assignee: WorkspaceUserCore;
}
