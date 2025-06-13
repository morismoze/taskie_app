import { IsEnum, IsOptional } from 'class-validator';
import {
  IsValidGoalAssignee,
  IsValidGoalDescription,
  IsValidGoalRequiredPoints,
  IsValidGoalTitle,
} from 'src/common/decorators/request-validation-decorators';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export class UpdateGoalRequest {
  @IsOptional()
  @IsValidGoalTitle()
  title?: string;

  @IsOptional()
  @IsValidGoalDescription()
  description?: string | null;

  @IsOptional()
  @IsValidGoalRequiredPoints()
  requiredPoints?: number;

  @IsOptional()
  @IsValidGoalAssignee()
  assigneeId?: string; // WorkspaceUser ID

  @IsOptional()
  @IsEnum(ProgressStatus)
  status?: ProgressStatus;

  constructor(
    title?: string,
    requiredPoints?: number,
    assigneeId?: string,
    status?: ProgressStatus,
    description?: string,
  ) {
    this.title = title;
    this.requiredPoints = requiredPoints;
    this.assigneeId = assigneeId;
    this.description = description;
    this.status = status;
  }
}
