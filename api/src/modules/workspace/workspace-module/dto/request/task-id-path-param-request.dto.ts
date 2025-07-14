import { IsNotEmpty, IsUUID } from 'class-validator';

export class TaskIdRequestPathParam {
  @IsNotEmpty()
  @IsUUID('4')
  taskId: string;

  constructor(taskId: string) {
    this.taskId = taskId;
  }
}
