import { User } from 'src/modules/user/domain/user.domain';
import { Workspace } from '../../workspace-module/domain/workspace.domain';
import { WorkspaceUserRole } from './workspace-user-role.enum';
import { WorkspaceUserStatus } from './workspace-user-status.enum';

export interface WorkspaceUser {
  id: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
  user: User;
  workspace: Workspace;
  workspaceRole: WorkspaceUserRole;
  status: WorkspaceUserStatus;
}
