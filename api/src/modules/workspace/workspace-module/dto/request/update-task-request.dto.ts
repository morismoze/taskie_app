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
  title: string;

  @IsOptional()
  @IsValidTaskDescription()
  description: string | null;

  @IsOptional()
  @IsValidTaskRewardPoints()
  rewardPoints: number;

  @IsOptional()
  @IsValidTaskDueDate()
  dueDate: Date | null;

  constructor(
    title: string,
    rewardPoints: number,
    description?: string | null,
    dueDate?: Date | null,
  ) {
    this.title = title;
    this.rewardPoints = rewardPoints;
    this.description = description ?? null;
    this.dueDate = dueDate ?? null;
  }
}
