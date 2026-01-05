import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsUUID } from 'class-validator';

export class RemoveTaskAssigneeRequest {
  @ApiProperty({
    description: 'WorkspaceUser ID',
    type: String,
    format: 'uuid',
  })
  @IsNotEmpty()
  @IsUUID('4')
  assigneeId: string; // Workspace user ID

  constructor(assigneeId: string) {
    this.assigneeId = assigneeId;
  }
}
