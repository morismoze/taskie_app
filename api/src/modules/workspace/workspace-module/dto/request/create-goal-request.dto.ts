import { IsOptional } from 'class-validator';
import {
  IsValidGoalAssignee,
  IsValidGoalDescription,
  IsValidGoalRequiredPoints,
  IsValidGoalTitle,
} from 'src/common/decorators/request-validation-decorators';

export class CreateGoalRequest {
  @IsValidGoalTitle()
  title: string;

  @IsOptional()
  @IsValidGoalDescription()
  description?: string;

  @IsValidGoalRequiredPoints()
  requiredPoints: number;

  @IsValidGoalAssignee()
  assignee: string; // WorkspaceUser ID

  constructor(
    title: string,
    requiredPoints: number,
    assignee: string,
    description?: string,
  ) {
    this.title = title;
    this.requiredPoints = requiredPoints;
    this.assignee = assignee;
    this.description = description;
  }
}
