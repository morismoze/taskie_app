import { IsHexadecimal, IsNotEmpty, IsString, Length } from 'class-validator';
import { WORKSPACE_INVITE_LINK_LENGTH } from 'src/common/helper/constants';

export class WorkspaceInviteTokenRequestPathParam {
  @IsNotEmpty()
  @IsString()
  @IsHexadecimal()
  @Length(WORKSPACE_INVITE_LINK_LENGTH)
  inviteToken: string;

  constructor(inviteToken: string) {
    this.inviteToken = inviteToken;
  }
}
