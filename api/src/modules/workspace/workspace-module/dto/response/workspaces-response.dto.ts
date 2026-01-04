import { ApiProperty } from '@nestjs/swagger';

export class WorkspaceCreatedByResponse {
  @ApiProperty()
  id!: string;

  @ApiProperty()
  firstName!: string;

  @ApiProperty()
  lastName!: string;

  @ApiProperty({ type: String, nullable: true })
  profileImageUrl!: string | null;
}

export class WorkspaceResponse {
  @ApiProperty()
  id!: string;

  @ApiProperty()
  name!: string;

  @ApiProperty({ type: String, nullable: true })
  description!: string | null;

  @ApiProperty({ type: String, nullable: true })
  pictureUrl!: string | null;

  @ApiProperty({ format: 'date-time' })
  createdAt!: string;

  // Will be null in the case user has deleted their account
  @ApiProperty({ type: () => WorkspaceCreatedByResponse, nullable: true })
  createdBy!: WorkspaceCreatedByResponse | null;
}
