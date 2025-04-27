import { UserResponse } from 'src/modules/user/dto/user-response.dto';
import { WorkspaceUserRole } from '../domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from '../domain/workspace-user-status.enum';

export interface WorkspaceUserDto {
  id: string;
  workspaceRole: WorkspaceUserRole;
  user: UserResponse;
  isOwner: boolean;
  status: WorkspaceUserStatus;
  createdAt: Date;
  deletedAt: Date | null;
}
