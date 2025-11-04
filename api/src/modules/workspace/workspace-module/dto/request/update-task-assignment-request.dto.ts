import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsEnum,
  IsNotEmpty,
  IsNotIn,
  IsUUID,
  ValidateNested,
} from 'class-validator';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { TASK_MAXIMUM_ASSIGNEES_COUNT } from 'src/modules/task/task-module/domain/task.constants';

export class TaskAssignmentUpdate {
  @IsNotEmpty()
  @IsUUID('4')
  assigneeId: string;

  @IsNotEmpty()
  @IsEnum(ProgressStatus)
  // ProgressStatus.Closed is not valid because
  // closing a task happens on different endpoint
  // and it is automatically set to ProgressStatus.Closed
  // for all assignees.
  @IsNotIn([ProgressStatus.CLOSED])
  status: ProgressStatus;

  constructor(assigneeId: string, status: ProgressStatus) {
    this.assigneeId = assigneeId;
    this.status = status;
  }
}

export class UpdateTaskAssignmentsRequest {
  @IsArray()
  @ValidateNested({ each: true })
  @ArrayMinSize(1)
  @ArrayMaxSize(TASK_MAXIMUM_ASSIGNEES_COUNT)
  @Type(() => TaskAssignmentUpdate)
  assignments: TaskAssignmentUpdate[];

  constructor(assignments: TaskAssignmentUpdate[]) {
    this.assignments = assignments;
  }
}
