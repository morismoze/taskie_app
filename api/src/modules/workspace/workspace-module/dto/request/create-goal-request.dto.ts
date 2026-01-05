import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional } from 'class-validator';
import {
  IsValidGoalAssignee,
  IsValidGoalDescription,
  IsValidGoalRequiredPoints,
  IsValidGoalTitle,
} from 'src/common/decorators/request-validation-decorators';

export class CreateGoalRequest {
  @ApiProperty()
  @IsValidGoalTitle()
  title!: string;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
  })
  @IsOptional()
  @IsValidGoalDescription()
  description!: string | null;

  @ApiProperty()
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
