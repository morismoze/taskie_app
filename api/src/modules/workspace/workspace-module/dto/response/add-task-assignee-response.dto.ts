import { ApiProperty } from '@nestjs/swagger';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { WorkspaceUserResponse } from './workspace-users-response.dto';

export class AddTaskAssigneeResponse extends WorkspaceUserResponse {
  @ApiProperty({ enum: ProgressStatus })
  status!: ProgressStatus;
}
