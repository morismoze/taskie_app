import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UnitOfWorkModule } from 'src/modules/unit-of-work/unit-of-work.module';
import { TaskEntity } from './task.entity';
import { TaskRepository } from './task.repository';
import { TaskRepositoryImpl } from './task.repository.impl';

@Module({
  imports: [TypeOrmModule.forFeature([TaskEntity]), UnitOfWorkModule],
  providers: [
    {
      provide: TaskRepository,
      useClass: TaskRepositoryImpl,
    },
  ],
  exports: [TaskRepository],
})
export class TaskPersistenceModule {}
