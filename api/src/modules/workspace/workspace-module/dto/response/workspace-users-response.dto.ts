import { ApiProperty } from '@nestjs/swagger';
import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';

export class WorkspaceUserCreatedByResponse {
  @ApiProperty()
  id!: string;

  @ApiProperty()
  firstName!: string;

  @ApiProperty()
  lastName!: string;

  @ApiProperty({ type: String, nullable: true })
  profileImageUrl!: string | null;
}

export class WorkspaceUserResponse {
  @ApiProperty({ description: 'WorkspaceUser ID' })
  id!: string;

  @ApiProperty()
  firstName!: string;

  @ApiProperty()
  lastName!: string;

  @ApiProperty({ type: String, nullable: true })
  email!: string | null;

  @ApiProperty({ type: String, nullable: true })
  profileImageUrl!: string | null;

  @ApiProperty({ enum: WorkspaceUserRole })
  role!: WorkspaceUserRole;

  @ApiProperty({ description: 'Core User ID' })
  userId!: string;

  @ApiProperty({ format: 'date-time' })
  createdAt!: string;

  @ApiProperty({
    description:
      'Will be null in the case workspace user was the one who created the workspace',
    type: () => WorkspaceUserCreatedByResponse,
    nullable: true,
  })
  createdBy!: WorkspaceUserCreatedByResponse | null;
}
