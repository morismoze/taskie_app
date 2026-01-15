import { ApiProperty } from '@nestjs/swagger';
import { ArrayMaxSize, ArrayMinSize, IsArray, IsUUID } from 'class-validator';
import { TASK_MAXIMUM_ASSIGNEES_COUNT } from 'src/modules/task/task-module/domain/task.constants';

export class AddTaskAssigneeRequest {
  @ApiProperty({
    description: 'Array of WorkspaceUser IDs',
    type: String,
    isArray: true,
    format: 'uuid',
    minItems: 1,
    maxItems: TASK_MAXIMUM_ASSIGNEES_COUNT,
  })
  @IsArray()
  @ArrayMinSize(1)
  // This is just defining a reasonable upper limit.
  // The actual max assignees count is done in the
  // service business layer.
  @ArrayMaxSize(TASK_MAXIMUM_ASSIGNEES_COUNT)
  @IsUUID('4', { each: true })
  assigneeIds: string[];

  constructor(assigneeIds: string[]) {
    this.assigneeIds = assigneeIds;
  }
}
