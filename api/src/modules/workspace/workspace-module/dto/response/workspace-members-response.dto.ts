import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';

export interface WorkspaceUserResponse {
  id: string; // WorkspaceUser ID
  firstName: string;
  lastName: string;
  profileImageUrl: string | null;
  role: WorkspaceUserRole;
}

export type WorkspaceUsersResponse = WorkspaceUserResponse[];
