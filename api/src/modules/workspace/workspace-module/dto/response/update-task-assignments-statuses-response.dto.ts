import { ApiProperty } from '@nestjs/swagger';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export class UpdateTaskAssignmentResponse {
  @ApiProperty({ description: 'WorkspaceUser ID', format: 'uuid' })
  assigneeId!: string;

  @ApiProperty({ enum: ProgressStatus })
  status!: ProgressStatus;
}
