import { Workspace } from 'src/modules/workspace/workspace-module/domain/workspace.domain';
import { WorkspaceUser } from 'src/modules/workspace/workspace-user-module/domain/workspace-user.domain';
import { ProgressStatus } from '../../task-module/domain/progress-status.enum';
import { Task } from '../../task-module/domain/task.domain';
import { GoalType } from './goal-type.enum';

export interface Goal {
  id: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
  assignees: WorkspaceUser[];
  createdBy: WorkspaceUser;
  description: string | null;
  requiredPoints: number | null;
  reward: string;
  status: ProgressStatus;
  tasks: Task[] | null;
  type: GoalType;
  workspace: Workspace;
}
