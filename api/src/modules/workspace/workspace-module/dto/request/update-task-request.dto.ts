import { IsOptional } from 'class-validator';
import {
  IsValidTaskDescription,
  IsValidTaskDueDate,
  IsValidTaskRewardPoints,
  IsValidTaskTitle,
} from 'src/common/decorators/request-validation-decorators';

export class UpdateTaskRequest {
  @IsOptional()
  @IsValidTaskTitle()
  title?: string;

  @IsOptional()
  @IsValidTaskDescription()
  description?: string | null;

  @IsOptional()
  @IsValidTaskRewardPoints()
  rewardPoints?: number;

  @IsOptional()
  @IsValidTaskDueDate()
  dueDate?: string;

  constructor(
    title: string,
    rewardPoints: number,
    description: string,
    dueDate: string,
  ) {
    this.title = title;
    this.rewardPoints = rewardPoints;
    this.description = description;
    this.dueDate = dueDate;
  }
}
