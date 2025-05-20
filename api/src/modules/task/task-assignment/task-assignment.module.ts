import { Module } from '@nestjs/common';
import { UnitOfWorkModule } from 'src/modules/unit-of-work/unit-of-work.module';
import { TaskModule } from '../task-module/task.module';
import { TaskAssignmentPersistenceModule } from './persistence/task-assignment-persistence.module';
import { TaskAssignmentService } from './task-assignment.service';

@Module({
  imports: [TaskAssignmentPersistenceModule, UnitOfWorkModule, TaskModule],
  providers: [TaskAssignmentService],
  exports: [TaskAssignmentService],
})
export class TaskAssignmentModule {}
