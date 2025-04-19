import { Workspace } from 'src/modules/workspace/workspace-module/domain/workspace.domain';
import { WorkspaceUser } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { ProgressStatus } from '../../progress-status.enum';
import { Task } from '../../task-module/persistence/task.entity';
import { GoalType } from '../goal-type.enum';

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
