import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TaskEntity } from 'src/modules/task/task-module/persistence/task.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { TaskSeedService } from './task-seed.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      TaskEntity,
      WorkspaceEntity,
      WorkspaceUserEntity,
    ]),
  ],
  providers: [TaskSeedService],
  exports: [TaskSeedService],
})
export class TaskSeedModule {}
