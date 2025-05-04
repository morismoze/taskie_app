import { Module } from '@nestjs/common';
import { TaskPersistenceModule } from './persistence/task-persistence.module';
import { TaskService } from './task.service';

@Module({
  imports: [TaskPersistenceModule],
  providers: [],
  exports: [TaskService],
})
export class TaskModule {}
