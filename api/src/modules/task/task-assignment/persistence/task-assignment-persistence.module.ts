import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TaskAssignmentEntity } from './task-assignment.entity';
import { TaskAssignmentRepository } from './task-assignment.repository';
import { TaskAssignmentRepositoryImpl } from './task-assignment.repository.impl';

@Module({
  imports: [TypeOrmModule.forFeature([TaskAssignmentEntity])],
  providers: [
    {
      provide: TaskAssignmentRepository,
      useClass: TaskAssignmentRepositoryImpl,
    },
  ],
  exports: [],
})
export class TaskAssignmentPersistenceModule {}
