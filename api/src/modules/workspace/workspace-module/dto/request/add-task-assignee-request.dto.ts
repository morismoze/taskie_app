import { ArrayMaxSize, ArrayMinSize, IsArray, IsUUID } from 'class-validator';
import { TASK_MAXIMUM_ASSIGNEES_COUNT } from 'src/modules/task/task-module/domain/task.constants';

export class AddTaskAssigneeRequest {
  @IsArray()
  @ArrayMinSize(1)
  // Not sure about this one as this request type is about
  // adding new assignees to already existing assignees list
  @ArrayMaxSize(TASK_MAXIMUM_ASSIGNEES_COUNT)
  @IsUUID('4', { each: true })
  assigneeIds: string[];

  constructor(assigneeIds: string[]) {
    this.assigneeIds = assigneeIds;
  }
}
