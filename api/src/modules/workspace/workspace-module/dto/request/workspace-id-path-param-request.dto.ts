import { IsNotEmpty, IsUUID } from 'class-validator';

export class WorkspaceIdRequestPathParam {
  @IsNotEmpty()
  @IsUUID('4')
  workspaceId: string;

  constructor(workspaceId: string) {
    this.workspaceId = workspaceId;
  }
}
