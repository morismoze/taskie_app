import { WorkspaceResponse } from 'src/modules/workspace/workspace-module/dto/response/workspaces-response.dto';
import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';

export interface UserResponse {
  id: string;
  firstName: string;
  lastName: string;
  roles: RolePerWorkspace[];
  email: string | null;
  profileImageUrl: string | null;
  createdAt: string;
}

export interface RolePerWorkspace {
  workspaceId: WorkspaceResponse['id'];
  role: WorkspaceUserRole;
}
