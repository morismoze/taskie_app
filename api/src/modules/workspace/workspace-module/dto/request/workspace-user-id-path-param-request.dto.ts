import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsUUID } from 'class-validator';

export class WorkspaceUserIdRequestPathParam {
  @ApiProperty({ format: 'uuid' })
  @IsNotEmpty()
  @IsUUID('4')
  workspaceUserId: string;

  constructor(workspaceUserId: string) {
    this.workspaceUserId = workspaceUserId;
  }
}
