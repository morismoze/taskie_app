import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional } from 'class-validator';
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

export class CreateGoalRequest {
  @ApiProperty({
    minLength: OBJECTIVE_NAME_MIN_CHARS,
    maxLength: OBJECTIVE_NAME_MAX_CHARS,
  })
  @IsValidGoalTitle()
  title!: string;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    maxLength: OBJECTIVE_DESCRIPTION_MAX_CHARS,
  })
  @IsOptional()
  @IsValidGoalDescription()
  description!: string | null;

  @ApiProperty({
    description: `Required points must be an integer between ${TASK_REWARD_POINTS_MINIMAL} and ${GOAL_REQUIRED_POINTS_MAXIMAL}, and a multiple of ${TASK_REWARD_POINTS_STEP}.`,
    minimum: TASK_REWARD_POINTS_MINIMAL,
    maximum: GOAL_REQUIRED_POINTS_MAXIMAL,
    multipleOf: TASK_REWARD_POINTS_STEP,
  })
  @IsValidGoalRequiredPoints()
  requiredPoints!: number;

  @ApiProperty({
    description: 'WorkspaceUser ID',
    format: 'uuid',
  })
  @IsValidGoalAssignee()
  assignee!: string;

  constructor(
    title: string,
    requiredPoints: number,
    assignee: string,
    description?: string | null,
  ) {
    this.title = title;
    this.requiredPoints = requiredPoints;
    this.assignee = assignee;
    this.description = description ?? null;
  }
}
