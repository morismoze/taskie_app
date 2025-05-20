import { IsEnum, IsNotEmpty, IsString } from 'class-validator';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export class TaskAssignmentStatusUpdate {
  @IsNotEmpty()
  @IsString()
  assigneeId: string;

  @IsNotEmpty()
  @IsEnum(ProgressStatus)
  status: ProgressStatus;

  constructor(assigneeId: string, status: ProgressStatus) {
    this.assigneeId = assigneeId;
    this.status = status;
  }
}

export class UpdateTaskAssignmentsStatusesRequest extends Array<TaskAssignmentStatusUpdate> {
  constructor(items: TaskAssignmentStatusUpdate[]) {
    super(...items);
  }
}
