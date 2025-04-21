import { WorkspaceUserRole } from './workspace-user-role.enum';
import { WorkspaceUserStatus } from './workspace-user-status.enum';

export interface WorkspaceUser {
  id: string;
  createdAt: Date;
  user: {
    id: string;
  };
  workspace: {
    id: string;
    name: string;
  };
  role: WorkspaceUserRole;
  status: WorkspaceUserStatus;
}
