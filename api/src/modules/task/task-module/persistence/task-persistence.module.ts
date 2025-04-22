import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TaskEntity } from './task.entity';
import { TaskRepository } from './task.repository';
import { TaskRepositoryImpl } from './task.repository.impl';

@Module({
  imports: [TypeOrmModule.forFeature([TaskEntity])],
  providers: [
    {
      provide: TaskRepository,
      useClass: TaskRepositoryImpl,
    },
  ],
  exports: [],
})
export class TaskPersistenceModule {}
