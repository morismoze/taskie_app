import { WorkspaceUserCore } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-core.domain';
import { TaskCore } from '../../task-module/domain/task-core.domain';
import { TaskAssignmentCore } from './task-assignment-core.domain';

export interface TaskAssignmentWithAssigneeCoreAndTaskCore
  extends TaskAssignmentCore {
  assignee: WorkspaceUserCore;
  task: TaskCore;
}
