import { IsOptional, NotEquals, ValidateIf } from 'class-validator';
import {
  IsValidGoalAssignee,
  IsValidGoalDescription,
  IsValidGoalRequiredPoints,
  IsValidGoalTitle,
} from 'src/common/decorators/request-validation-decorators';

export class UpdateGoalRequest {
  @IsValidGoalTitle()
  @NotEquals(null)
  @ValidateIf((_, value) => value !== undefined)
  title?: string;

  @IsOptional()
  @IsValidGoalDescription()
  // Can be set to null - resets it
  description?: string | null;

  @IsValidGoalRequiredPoints()
  @NotEquals(null)
  @ValidateIf((_, value) => value !== undefined)
  requiredPoints?: number;

  @IsValidGoalAssignee()
  @NotEquals(null)
  @ValidateIf((_, value) => value !== undefined)
  assigneeId?: string; // WorkspaceUser ID
}
