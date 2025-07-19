import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';

export interface WorkspaceUserResponse {
  id: string; // WorkspaceUser ID
  firstName: string;
  lastName: string;
  email: string | null;
  profileImageUrl: string | null;
  role: WorkspaceUserRole;
  userId: string; // core User ID
}

export type WorkspaceUsersResponse = WorkspaceUserResponse[];
