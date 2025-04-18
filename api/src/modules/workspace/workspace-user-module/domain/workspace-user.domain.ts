import { WorkspaceUserRole } from './workspace-user-role.enum';

export interface WorkspaceUserDomain {
  id: string;
  createdAt: Date;
  userId: string;
  workspaceId: string;
  role: WorkspaceUserRole;
  isOwner: boolean;
}
