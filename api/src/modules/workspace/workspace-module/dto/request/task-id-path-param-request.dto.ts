import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsUUID } from 'class-validator';

export class TaskIdRequestPathParam {
  @ApiProperty({ format: 'uuid' })
  @IsNotEmpty()
  @IsUUID('4')
  taskId: string;

  constructor(taskId: string) {
    this.taskId = taskId;
  }
}
