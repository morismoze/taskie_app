import { IsNotEmpty, IsUUID } from 'class-validator';

export class AddTaskAssigneeRequest {
  @IsNotEmpty()
  @IsUUID('4')
  assigneeId: string; // Workspace user ID

  constructor(assigneeId: string) {
    this.assigneeId = assigneeId;
  }
}
