import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsOptional,
  IsUUID,
} from 'class-validator';
import {
  IsValidTaskDescription,
  IsValidTaskDueDate,
  IsValidTaskRewardPoints,
  IsValidTaskTitle,
} from 'src/common/decorators/request-validation-decorators';
import {
  OBJECTIVE_DESCRIPTION_MAX_CHARS,
  OBJECTIVE_NAME_MAX_CHARS,
  OBJECTIVE_NAME_MIN_CHARS,
} from 'src/common/helper/constants';
import {
  TASK_MAXIMUM_ASSIGNEES_COUNT,
  TASK_REWARD_POINTS_MAXIMAL,
  TASK_REWARD_POINTS_MINIMAL,
  TASK_REWARD_POINTS_STEP,
} from 'src/modules/task/task-module/domain/task.constants';

export class CreateTaskRequest {
  @ApiProperty({
    minLength: OBJECTIVE_NAME_MIN_CHARS,
    maxLength: OBJECTIVE_NAME_MAX_CHARS,
  })
  @IsValidTaskTitle()
  title: string;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    maxLength: OBJECTIVE_DESCRIPTION_MAX_CHARS,
  })
  @IsOptional()
  @IsValidTaskDescription()
  description?: string | null;

  @ApiProperty({
    description: `Reward points must be an integer between ${TASK_REWARD_POINTS_MINIMAL} and ${TASK_REWARD_POINTS_MAXIMAL}, and a multiple of ${TASK_REWARD_POINTS_STEP}.`,
    minimum: TASK_REWARD_POINTS_MINIMAL,
    maximum: TASK_REWARD_POINTS_MAXIMAL,
    multipleOf: TASK_REWARD_POINTS_STEP,
  })
  @IsValidTaskRewardPoints()
  rewardPoints: number;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    format: 'date-time',
    description: 'Due date in ISO 8601 (UTC). Must not be in the past.',
  })
  @IsOptional()
  @IsValidTaskDueDate()
  dueDate?: string | null;

  @ApiProperty({
    description: 'Array of WorkspaceUser IDs',
    type: String,
    isArray: true,
    format: 'uuid',
    minItems: 1,
    maxItems: TASK_MAXIMUM_ASSIGNEES_COUNT,
  })
  @IsArray()
  @IsUUID('4', { each: true })
  @ArrayMinSize(1)
  @ArrayMaxSize(TASK_MAXIMUM_ASSIGNEES_COUNT)
  assignees: string[]; // Array of WorkspaceUser IDs

  constructor(
    title: string,
    rewardPoints: number,
    assignees: string[],
    description?: string | null,
    dueDate?: string | null,
  ) {
    this.title = title;
    this.rewardPoints = rewardPoints;
    this.assignees = assignees;
    this.description = description || null;
    this.dueDate = dueDate || null;
  }
}
