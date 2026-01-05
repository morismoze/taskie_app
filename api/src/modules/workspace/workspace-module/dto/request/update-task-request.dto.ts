import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, NotEquals, ValidateIf } from 'class-validator';
import {
  IsValidTaskDescription,
  IsValidTaskDueDate,
  IsValidTaskRewardPoints,
  IsValidTaskTitle,
} from 'src/common/decorators/request-validation-decorators';

export class UpdateTaskRequest {
  @ApiPropertyOptional()
  @IsValidTaskTitle()
  @NotEquals(null)
  @ValidateIf((_, value) => value !== undefined)
  title?: string;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Setting it to null, removes description',
  })
  @IsOptional()
  @IsValidTaskDescription()
  // Can be set to null - resets it
  description?: string | null;

  @ApiPropertyOptional()
  @IsValidTaskRewardPoints()
  @NotEquals(null)
  @ValidateIf((_, value) => value !== undefined)
  rewardPoints?: number;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    format: 'date',
    description: 'Setting it to null, removes due date',
  })
  @IsOptional()
  @IsValidTaskDueDate()
  // Can be set to null - resets it
  dueDate?: string | null;
}
