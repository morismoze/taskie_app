import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UnitOfWorkModule } from 'src/modules/unit-of-work/unit-of-work.module';
import { TaskAssignmentEntity } from './task-assignment.entity';
import { TaskAssignmentRepository } from './task-assignment.repository';
import { TaskAssignmentRepositoryImpl } from './task-assignment.repository.impl';

@Module({
  imports: [TypeOrmModule.forFeature([TaskAssignmentEntity]), UnitOfWorkModule],
  providers: [
    {
      provide: TaskAssignmentRepository,
      useClass: TaskAssignmentRepositoryImpl,
    },
  ],
  exports: [TaskAssignmentRepository],
})
export class TaskAssignmentPersistenceModule {}
