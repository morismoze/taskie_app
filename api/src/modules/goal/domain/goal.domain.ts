import { RootDomain } from 'src/modules/database/domain/root.domain';
import { Workspace } from 'src/modules/workspace/workspace-module/domain/workspace.domain';
import { WorkspaceUser } from 'src/modules/workspace/workspace-user-module/domain/workspace-user.domain';
import { ProgressStatus } from '../../task/task-module/domain/progress-status.enum';

export interface Goal extends RootDomain {
  assignee: WorkspaceUser;
  workspace: Workspace;
  title: string;
  description: string | null;
  requiredPoints: number;
  status: ProgressStatus;
  createdBy: WorkspaceUser | null;
}
