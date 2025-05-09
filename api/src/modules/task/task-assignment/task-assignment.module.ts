import { Module } from '@nestjs/common';
import { TaskAssignmentPersistenceModule } from './persistence/task-assignment-persistence.module';
import { TaskAssignmentService } from './task-assignment.service';

@Module({
  imports: [TaskAssignmentPersistenceModule],
  providers: [TaskAssignmentService],
  exports: [TaskAssignmentService],
})
export class TaskAssignmentModule {}
