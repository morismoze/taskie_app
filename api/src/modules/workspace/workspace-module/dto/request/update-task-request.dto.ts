import { IsOptional, NotEquals, ValidateIf } from 'class-validator';
import {
  IsValidTaskDescription,
  IsValidTaskDueDate,
  IsValidTaskRewardPoints,
  IsValidTaskTitle,
} from 'src/common/decorators/request-validation-decorators';

export class UpdateTaskRequest {
  @IsValidTaskTitle()
  @NotEquals(null)
  @ValidateIf((_, value) => value !== undefined)
  title?: string;

  @IsOptional()
  @IsValidTaskDescription()
  // Can be set to null - resets it
  description?: string | null;

  @IsValidTaskRewardPoints()
  @NotEquals(null)
  @ValidateIf((_, value) => value !== undefined)
  rewardPoints?: number;

  @IsOptional()
  @IsValidTaskDueDate()
  // Can be set to null - resets it
  dueDate?: string | null;
}
