import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, NotEquals, ValidateIf } from 'class-validator';
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
  TASK_REWARD_POINTS_MAXIMAL,
  TASK_REWARD_POINTS_MINIMAL,
  TASK_REWARD_POINTS_STEP,
} from 'src/modules/task/task-module/domain/task.constants';

export class UpdateTaskRequest {
  @ApiPropertyOptional({
    minLength: OBJECTIVE_NAME_MIN_CHARS,
    maxLength: OBJECTIVE_NAME_MAX_CHARS,
  })
  @IsValidTaskTitle()
  @NotEquals(null)
  @ValidateIf((_, v) => v !== undefined) // Optional, but null is invalid
  title?: string;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Setting it to null, removes description',
    maxLength: OBJECTIVE_DESCRIPTION_MAX_CHARS,
  })
  @IsOptional() // Optional, and null is valid
  @IsValidTaskDescription()
  description?: string | null;

  @ApiPropertyOptional({
    description: `Reward points must be an integer between ${TASK_REWARD_POINTS_MINIMAL} and ${TASK_REWARD_POINTS_MAXIMAL}, and a multiple of ${TASK_REWARD_POINTS_STEP}.`,
    minimum: TASK_REWARD_POINTS_MINIMAL,
    maximum: TASK_REWARD_POINTS_MAXIMAL,
    multipleOf: TASK_REWARD_POINTS_STEP,
  })
  @IsValidTaskRewardPoints()
  @ValidateIf((_, v) => v !== undefined) // Optional, but null is invalid
  rewardPoints?: number;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    format: 'date-time',
    description: 'Due date in ISO 8601 (UTC). Must not be in the past.',
  })
  @IsOptional() // Optional, and null is valid
  @IsValidTaskDueDate()
  dueDate?: string | null;
}
