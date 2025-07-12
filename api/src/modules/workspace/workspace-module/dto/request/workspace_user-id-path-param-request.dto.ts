import { IsNotEmpty, IsUUID } from 'class-validator';

export class WorkspaceUserIdRequestPathParam {
  @IsNotEmpty()
  @IsUUID()
  workspaceUserId: string;

  constructor(workspaceUserId: string) {
    this.workspaceUserId = workspaceUserId;
  }
}
