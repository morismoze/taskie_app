import { IsNotEmpty, IsUUID } from 'class-validator';

export class TaskAssigneeIdRequestPathParam {
  @IsNotEmpty()
  @IsUUID()
  assigneeId: string;

  constructor(assigneeId: string) {
    this.assigneeId = assigneeId;
  }
}
