import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsUUID } from 'class-validator';

export class WorkspaceIdRequestPathParam {
  @ApiProperty({ format: 'uuid' })
  @IsNotEmpty()
  @IsUUID('4')
  workspaceId: string;

  constructor(workspaceId: string) {
    this.workspaceId = workspaceId;
  }
}
