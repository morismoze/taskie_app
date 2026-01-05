import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, NotEquals, ValidateIf } from 'class-validator';
import {
  IsValidGoalAssignee,
  IsValidGoalDescription,
  IsValidGoalRequiredPoints,
  IsValidGoalTitle,
} from 'src/common/decorators/request-validation-decorators';

export class UpdateGoalRequest {
  @ApiPropertyOptional()
  @IsValidGoalTitle()
  @NotEquals(null)
  @ValidateIf((_, value) => value !== undefined)
  title?: string;

  @ApiPropertyOptional({
    description: 'Setting it to null, removes description',
    type: String,
    nullable: true,
  })
  @IsOptional()
  @IsValidGoalDescription()
  description?: string | null;

  @ApiPropertyOptional()
  @IsValidGoalRequiredPoints()
  @NotEquals(null)
  @ValidateIf((_, value) => value !== undefined)
  requiredPoints?: number;

  @ApiPropertyOptional({
    format: 'uuid',
  })
  @IsValidGoalAssignee()
  @NotEquals(null)
  @ValidateIf((_, value) => value !== undefined)
  assigneeId?: string;
}
