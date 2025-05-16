import { IsNotEmpty, IsUUID } from 'class-validator';

export class WorkspaceIdRequestPathParam {
  @IsNotEmpty()
  @IsUUID()
  workspaceId: string;

  constructor(workspaceId: string) {
    this.workspaceId = workspaceId;
  }
}
