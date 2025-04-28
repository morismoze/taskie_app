import { UserResponse } from 'src/modules/user/dto/user-response.dto';
import { WorkspaceUserRole } from '../domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from '../domain/workspace-user-status.enum';

export interface WorkspaceUserDto {
  id: string;
  workspaceRole: WorkspaceUserRole;
  user: UserResponse;
  status: WorkspaceUserStatus;
  createdAt: Date;
  deletedAt: Date | null;
  createdBy: WorkspaceUserDto | null;
}
