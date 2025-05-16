import { IsEnum, IsNotEmpty } from 'class-validator';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export class SetTaskAssignmentStatusRequest {
  @IsNotEmpty()
  @IsEnum(ProgressStatus)
  status: ProgressStatus;

  constructor(status: ProgressStatus) {
    this.status = status;
  }
}
