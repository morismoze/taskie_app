import { Module } from '@nestjs/common';
import { UnitOfWorkModule } from 'src/modules/unit-of-work/unit-of-work.module';
import { TaskPersistenceModule } from './persistence/task-persistence.module';
import { TaskService } from './task.service';

@Module({
  imports: [TaskPersistenceModule, UnitOfWorkModule],
  providers: [TaskService],
  exports: [TaskService],
})
export class TaskModule {}
