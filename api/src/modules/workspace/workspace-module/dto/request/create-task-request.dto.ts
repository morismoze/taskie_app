import { ArrayMinSize, IsArray, IsOptional, IsString } from 'class-validator';
import {
  IsValidTaskDescription,
  IsValidTaskDueDate,
  IsValidTaskRewardPoints,
  IsValidTaskTitle,
} from 'src/common/decorators/request-validation-decorators';

export class CreateTaskRequest {
  @IsValidTaskTitle()
  title: string;

  @IsValidTaskDescription()
  description: string | null;

  @IsValidTaskRewardPoints()
  rewardPoints: number;

  @IsOptional()
  @IsValidTaskDueDate()
  dueDate: Date | null;

  @IsArray()
  @IsString({ each: true })
  @ArrayMinSize(1)
  assignees: string[]; // Array of WorkspaceUser IDs

  constructor(
    title: string,
    rewardPoints: number,
    assignees: string[],
    description?: string | null,
    dueDate?: Date | null,
  ) {
    this.title = title;
    this.rewardPoints = rewardPoints;
    this.assignees = assignees;
    this.description = description ?? null;
    this.dueDate = dueDate ?? null;
  }
}
