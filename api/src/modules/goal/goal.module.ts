import { Module } from '@nestjs/common';
import { TaskAssignmentModule } from '../task/task-assignment/task-assignment.module';
import { GoalService } from './goal.service';
import { GoalPersistenceModule } from './persistence/goal-persistence.module';

@Module({
  imports: [GoalPersistenceModule, TaskAssignmentModule],
  providers: [GoalService],
  exports: [GoalService],
})
export class GoalModule {}
