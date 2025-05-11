import { IsNotEmpty, IsUUID } from 'class-validator';

export class WorkspaceIdRequestParam {
  @IsNotEmpty()
  @IsUUID()
  workspaceId: string;

  constructor(workspaceId: string) {
    this.workspaceId = workspaceId;
  }
}
