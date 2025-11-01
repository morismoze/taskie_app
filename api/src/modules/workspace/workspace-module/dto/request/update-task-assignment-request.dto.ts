import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsEnum,
  IsNotEmpty,
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
