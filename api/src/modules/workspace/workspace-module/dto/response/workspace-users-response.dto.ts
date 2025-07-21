import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';

export interface WorkspaceUserResponse {
  id: string; // WorkspaceUser ID
  firstName: string;
  lastName: string;
  email: string | null;
  profileImageUrl: string | null;
  role: WorkspaceUserRole;
  userId: string; // core User ID
  createdAt: string;
  // Will be null in the case workspace user was the one
  // who created the workspace
  createdBy: {
    firstName: WorkspaceUserResponse['firstName'];
    lastName: WorkspaceUserResponse['lastName'];
    profileImageUrl: WorkspaceUserResponse['profileImageUrl'];
  } | null;
}

export type WorkspaceUsersResponse = WorkspaceUserResponse[];
