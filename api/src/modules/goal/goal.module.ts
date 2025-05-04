import { Module } from '@nestjs/common';
import { GoalPersistenceModule } from './persistence/goal-persistence.module';

@Module({
  imports: [GoalPersistenceModule],
  providers: [],
  exports: [],
})
export class GoalModule {}
