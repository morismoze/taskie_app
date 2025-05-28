import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsEnum,
  IsNotEmpty,
  IsString,
  ValidateNested,
} from 'class-validator';
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

export class UpdateTaskAssignmentsStatusesRequest {
  @IsArray()
  @ValidateNested({ each: true })
  @ArrayMinSize(1)
  @ArrayMaxSize(1000) // Just a safe upper limit
  @Type(() => TaskAssignmentStatusUpdate)
  assignments: TaskAssignmentStatusUpdate[];

  constructor(assignments: TaskAssignmentStatusUpdate[]) {
    this.assignments = assignments;
  }
}
