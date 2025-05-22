import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TaskAssignmentEntity } from 'src/modules/task/task-assignment/persistence/task-assignment.entity';
import { TaskEntity } from 'src/modules/task/task-module/persistence/task.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { TaskAssignmentSeedService } from './task-assignment-seed.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      TaskAssignmentEntity,
      TaskEntity,
      WorkspaceEntity,
      WorkspaceUserEntity,
    ]),
  ],
  providers: [TaskAssignmentSeedService],
  exports: [TaskAssignmentSeedService],
})
export class TaskAssignmentSeedModule {}
