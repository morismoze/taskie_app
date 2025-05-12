import { Type } from 'class-transformer';
import {
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  Max,
  Min,
  Validate,
} from 'class-validator';
import { IsMultipleOfConstraint } from 'src/common/validators/is-multiple-of.validator';
import { TASK_REWARD_POINTS_MINIMAL } from 'src/modules/task/task-module/domain/reward-points.domain';

export class CreateGoalRequest {
  @IsNotEmpty()
  @IsString()
  title: string;

  @IsOptional()
  @IsString()
  description: string | null;

  @IsNotEmpty()
  @Type(() => Number)
  @IsInt()
  @Min(TASK_REWARD_POINTS_MINIMAL)
  @Max(1000000) // This is trying to define a reasonable upper limit
  @Validate(IsMultipleOfConstraint, [TASK_REWARD_POINTS_MINIMAL])
  requiredPoints: number;

  @IsNotEmpty()
  @IsString({ each: true })
  assignee: string; // WorkspaceUser ID

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
