import { Type } from 'class-transformer';
import {
  IsEnum,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  Max,
  Min,
  Validate,
} from 'class-validator';
import { IsMultipleOfConstraint } from 'src/common/validators/is-multiple-of.validator';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import {
  TASK_REWARD_POINTS_MINIMAL,
  TASK_REWARD_POINTS_STEP,
} from 'src/modules/task/task-module/domain/reward-points.domain';

export class UpdateGoalRequest {
  @IsOptional()
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
  @Validate(IsMultipleOfConstraint, [TASK_REWARD_POINTS_STEP])
  requiredPoints: number;

  @IsNotEmpty()
  @IsString({ each: true })
  assigneeId: string; // WorkspaceUser ID

  @IsNotEmpty()
  @IsEnum(ProgressStatus)
  status: ProgressStatus;

  constructor(
    title: string,
    requiredPoints: number,
    assigneeId: string,
    status: ProgressStatus,
    description?: string | null,
  ) {
    this.title = title;
    this.requiredPoints = requiredPoints;
    this.assigneeId = assigneeId;
    this.description = description ?? null;
    this.status = status;
  }
}
