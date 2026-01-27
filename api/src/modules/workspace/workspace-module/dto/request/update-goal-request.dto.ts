import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, NotEquals, ValidateIf } from 'class-validator';
import {
  IsValidGoalAssignee,
  IsValidGoalDescription,
  IsValidGoalRequiredPoints,
  IsValidGoalTitle,
} from 'src/common/decorators/request-validation-decorators';
import {
  OBJECTIVE_DESCRIPTION_MAX_CHARS,
  OBJECTIVE_NAME_MAX_CHARS,
  OBJECTIVE_NAME_MIN_CHARS,
} from 'src/common/helper/constants';
import { GOAL_REQUIRED_POINTS_MAXIMAL } from 'src/modules/goal/domain/goal.constants';
import {
  TASK_REWARD_POINTS_MINIMAL,
  TASK_REWARD_POINTS_STEP,
} from 'src/modules/task/task-module/domain/task.constants';

export class UpdateGoalRequest {
  @ApiPropertyOptional({
    minLength: OBJECTIVE_NAME_MIN_CHARS,
    maxLength: OBJECTIVE_NAME_MAX_CHARS,
  })
  @IsValidGoalTitle()
  @NotEquals(null)
  @ValidateIf((_, v) => v !== undefined) // Optional, but null is invalid
  title?: string;

  @ApiPropertyOptional({
    description: 'Setting it to null, removes description',
    type: String,
    nullable: true,
    maxLength: OBJECTIVE_DESCRIPTION_MAX_CHARS,
  })
  @IsOptional() // Optional, and null is valid
  @IsValidGoalDescription()
  description?: string | null;

  @ApiPropertyOptional({
    description: `Required points must be an integer between ${TASK_REWARD_POINTS_MINIMAL} and ${GOAL_REQUIRED_POINTS_MAXIMAL}, and a multiple of ${TASK_REWARD_POINTS_STEP}.`,
    minimum: TASK_REWARD_POINTS_MINIMAL,
    maximum: GOAL_REQUIRED_POINTS_MAXIMAL,
    multipleOf: TASK_REWARD_POINTS_STEP,
  })
  @IsValidGoalRequiredPoints()
  @NotEquals(null)
  @ValidateIf((_, v) => v !== undefined) // Optional, but null is invalid
  requiredPoints?: number;

  @ApiPropertyOptional({
    format: 'uuid',
  })
  @IsValidGoalAssignee()
  @NotEquals(null)
  @ValidateIf((_, v) => v !== undefined) // Optional, but null is invalid
  assigneeId?: string;
}
