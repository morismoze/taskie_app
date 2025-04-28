import { Workspace } from 'src/modules/workspace/workspace-module/domain/workspace.domain';
import { WorkspaceUser } from 'src/modules/workspace/workspace-user-module/domain/workspace-user.domain';
import { Goal } from '../../goal-module/domain/goal.domain';
import { ProgressStatus } from './progress-status.enum';

export interface Task {
  id: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
  assignees: WorkspaceUser[];
  createdBy: WorkspaceUser;
  description: string | null;
  goal: Goal[] | null;
  rewardPoints: number;
  status: ProgressStatus;
  rewardTitle: string;
  workspace: Workspace;
}
