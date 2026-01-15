import { ApiProperty } from '@nestjs/swagger';
import { IsHexadecimal, IsNotEmpty, IsString, Length } from 'class-validator';
import { WORKSPACE_INVITE_TOKEN_LENGTH } from 'src/common/helper/constants';

export class WorkspaceInviteTokenRequestPathParam {
  @ApiProperty({
    description: 'Workspace invite token (24-char hex string)',
    example: 'a3f9c1d2e4b5678901c2d3e4',
    minLength: WORKSPACE_INVITE_TOKEN_LENGTH,
    maxLength: WORKSPACE_INVITE_TOKEN_LENGTH,
  })
  @IsNotEmpty()
  @IsString()
  @IsHexadecimal()
  @Length(WORKSPACE_INVITE_TOKEN_LENGTH)
  inviteToken: string;

  constructor(inviteToken: string) {
    this.inviteToken = inviteToken;
  }
}
