import { WorkspaceUserRole } from '../domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from '../domain/workspace-user-status.enum';

export interface WorkspaceUserMembershipDto {
  id: string;
  workspaceId: string;
  role: WorkspaceUserRole;
  isOwner: boolean;
  status: WorkspaceUserStatus;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date;
}
