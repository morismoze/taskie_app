import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';

export class RolePerWorkspace {
  @ApiProperty()
  workspaceId!: string;

  @ApiProperty({ enum: WorkspaceUserRole })
  role!: WorkspaceUserRole;
}

export class UserResponse {
  @ApiProperty()
  id!: string;

  @ApiProperty()
  firstName!: string;

  @ApiProperty()
  lastName!: string;

  @ApiProperty({ type: [RolePerWorkspace] })
  roles!: RolePerWorkspace[];

  @ApiPropertyOptional({ type: String, nullable: true })
  email!: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  profileImageUrl!: string | null;

  @ApiProperty()
  createdAt!: string;
}
