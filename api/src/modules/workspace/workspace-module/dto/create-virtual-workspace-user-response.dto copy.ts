import { WorkspaceUserDto } from './user-workspaces-response.dto';

export interface CreateVirtualWorkspaceUserResponse extends WorkspaceUserDto {
  userId: string;
}
