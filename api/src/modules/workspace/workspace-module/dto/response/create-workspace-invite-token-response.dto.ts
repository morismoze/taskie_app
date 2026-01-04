import { ApiProperty } from '@nestjs/swagger';

export class CreateWorkspaceInviteTokenResponse {
  @ApiProperty()
  token!: string;

  @ApiProperty({ format: 'date-time' })
  expiresAt!: string;
}
