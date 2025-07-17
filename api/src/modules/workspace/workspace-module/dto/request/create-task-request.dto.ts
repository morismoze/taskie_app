import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsOptional,
  IsUUID,
} from 'class-validator';
import {
  IsValidTaskDescription,
  IsValidTaskDueDate,
  IsValidTaskRewardPoints,
  IsValidTaskTitle,
} from 'src/common/decorators/request-validation-decorators';
import { TASK_MAXIMUM_ASSIGNEES_COUNT } from 'src/modules/task/task-module/domain/task.constants';

export class CreateTaskRequest {
  @IsValidTaskTitle()
  title: string;

  @IsOptional()
  @IsValidTaskDescription()
  description: string | null;

  @IsValidTaskRewardPoints()
  rewardPoints: number;

  @IsOptional()
  @IsValidTaskDueDate()
  dueDate: string | null;

  @IsArray()
  @IsUUID('4', { each: true })
  @ArrayMinSize(1)
  @ArrayMaxSize(TASK_MAXIMUM_ASSIGNEES_COUNT)
  assignees: string[]; // Array of WorkspaceUser IDs

  constructor(
    title: string,
    rewardPoints: number,
    assignees: string[],
    description?: string | null,
    dueDate?: string | null,
  ) {
    this.title = title;
    this.rewardPoints = rewardPoints;
    this.assignees = assignees;
    this.description = description ?? null;
    this.dueDate = dueDate ?? null;
  }
}
