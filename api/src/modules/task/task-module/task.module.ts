import { Module } from '@nestjs/common';
import { TaskPersistenceModule } from './persistence/task-persistence.module';

@Module({
  imports: [TaskPersistenceModule],
  providers: [],
  exports: [],
})
export class TaskModule {}
