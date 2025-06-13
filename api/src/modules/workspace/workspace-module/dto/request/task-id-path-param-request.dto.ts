import { IsNotEmpty, IsUUID } from 'class-validator';

export class TaskIdRequestPathParam {
  @IsNotEmpty()
  @IsUUID()
  taskId: string;

  constructor(taskId: string) {
    this.taskId = taskId;
  }
}
