import { IsNotEmpty, IsUUID } from 'class-validator';

export class GoalIdRequestPathParam {
  @IsNotEmpty()
  @IsUUID()
  goalId: string;

  constructor(goalId: string) {
    this.goalId = goalId;
  }
}
