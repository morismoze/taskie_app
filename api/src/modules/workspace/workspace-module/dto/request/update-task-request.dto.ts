import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, NotEquals, ValidateIf } from 'class-validator';
import {
  IsValidTaskDescription,
  IsValidTaskDueDate,
  IsValidTaskRewardPoints,
  IsValidTaskTitle,
} from 'src/common/decorators/request-validation-decorators';

export class UpdateTaskRequest {
  @ApiPropertyOptional({ type: String, nullable: false })
  @IsValidTaskTitle()
  @NotEquals(null)
  @ValidateIf((_, value) => value !== undefined)
  title?: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsValidTaskDescription()
  // Can be set to null - resets it
  description?: string | null;

  @ApiPropertyOptional({ type: String, nullable: false })
  @IsValidTaskRewardPoints()
  @NotEquals(null)
  @ValidateIf((_, value) => value !== undefined)
  rewardPoints?: number;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsValidTaskDueDate()
  // Can be set to null - resets it
  dueDate?: string | null;
}
