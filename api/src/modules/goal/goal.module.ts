import { Module } from '@nestjs/common';
import { GoalService } from './goal.service';
import { GoalPersistenceModule } from './persistence/goal-persistence.module';

@Module({
  imports: [GoalPersistenceModule],
  providers: [GoalService],
  exports: [GoalService],
})
export class GoalModule {}
