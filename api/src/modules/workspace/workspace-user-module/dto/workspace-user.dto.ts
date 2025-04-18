import { WorkspaceUserRole } from '../domain/workspace-user-role.enum';

export interface WorkspaceUserMembershipDto {
  id: string;
  createdAt: Date;
  workspaceId: string;
  role: WorkspaceUserRole;
  isOwner: boolean;
}
