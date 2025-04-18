import { WorkspaceUserMembershipDto } from 'src/modules/workspace/workspace-user-module/dto/workspace-user.dto';

export interface UserDto {
  id: string;
  firstName: string;
  lastName: string;
  email: string | null;
  profileImageUrl: string | null;
  createdAt: Date;
  memberships: WorkspaceUserMembershipDto[];
}
