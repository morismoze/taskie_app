import { IsNotEmpty, IsUUID } from 'class-validator';

export class WorkspaceUserIdRequestPathParam {
  @IsNotEmpty()
  @IsUUID('4')
  workspaceUserId: string;

  constructor(workspaceUserId: string) {
    this.workspaceUserId = workspaceUserId;
  }
}
