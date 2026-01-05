import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsIn,
  IsNotEmpty,
  IsUUID,
  ValidateNested,
} from 'class-validator';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { TASK_MAXIMUM_ASSIGNEES_COUNT } from 'src/modules/task/task-module/domain/task.constants';

const AllowedProgressStatusUpdateStatuses = [
  ProgressStatus.IN_PROGRESS,
  ProgressStatus.COMPLETED,
  ProgressStatus.COMPLETED_AS_STALE,
  ProgressStatus.NOT_COMPLETED,
] as const;
type AllowedProgressStatusUpdateStatuses =
  (typeof AllowedProgressStatusUpdateStatuses)[number];

export class TaskAssignmentUpdate {
  @ApiProperty({
    description: 'WorkspaceUser ID',
    format: 'uuid',
  })
  @IsNotEmpty()
  @IsUUID('4')
  assigneeId!: string;

  @ApiProperty({
    description:
      'New progress status for this assignee. CLOSED is not allowed here; use the task close endpoint.',
    enum: AllowedProgressStatusUpdateStatuses,
  })
  @IsNotEmpty()
  @IsIn(AllowedProgressStatusUpdateStatuses)
  status!: AllowedProgressStatusUpdateStatuses;

  constructor(assigneeId: string, status: AllowedProgressStatusUpdateStatuses) {
    this.assigneeId = assigneeId;
    this.status = status;
  }
}

export class UpdateTaskAssignmentsRequest {
  @ApiProperty({
    type: () => TaskAssignmentUpdate,
    isArray: true,
    minItems: 1,
    maxItems: TASK_MAXIMUM_ASSIGNEES_COUNT,
  })
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
