import { IsNotEmpty, IsUUID } from 'class-validator';

export class GoalIdRequestPathParam {
  @IsNotEmpty()
  @IsUUID('4')
  goalId: string;

  constructor(goalId: string) {
    this.goalId = goalId;
  }
}
