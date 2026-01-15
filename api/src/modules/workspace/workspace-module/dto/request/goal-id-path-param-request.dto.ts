import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsUUID } from 'class-validator';

export class GoalIdRequestPathParam {
  @ApiProperty({ format: 'uuid' })
  @IsNotEmpty()
  @IsUUID('4')
  goalId: string;

  constructor(goalId: string) {
    this.goalId = goalId;
  }
}
