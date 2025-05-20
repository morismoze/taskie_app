import { Type } from 'class-transformer';
import {
  IsDate,
  IsInt,
  IsOptional,
  IsString,
  Max,
  Min,
  Validate,
} from 'class-validator';
import { IsMultipleOfConstraint } from 'src/common/validators/is-multiple-of.validator';
import {
  TASK_REWARD_POINTS_MAXIMAL,
  TASK_REWARD_POINTS_MINIMAL,
  TASK_REWARD_POINTS_STEP,
} from 'src/modules/task/task-module/domain/reward-points.domain';

export class UpdateTaskRequest {
  @IsOptional()
  @IsString()
  title: string;

  @IsOptional()
  @IsString()
  description: string | null;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(TASK_REWARD_POINTS_MINIMAL)
  @Max(TASK_REWARD_POINTS_MAXIMAL)
  @Validate(IsMultipleOfConstraint, [TASK_REWARD_POINTS_STEP])
  rewardPoints: number;

  @IsOptional()
  @Type(() => Date)
  @IsDate()
  dueDate: Date | null;

  constructor(
    title: string,
    rewardPoints: number,
    description?: string | null,
    dueDate?: Date | null,
  ) {
    this.title = title;
    this.rewardPoints = rewardPoints;
    this.description = description ?? null;
    this.dueDate = dueDate ?? null;
  }
}
