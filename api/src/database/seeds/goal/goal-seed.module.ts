import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { GoalEntity } from 'src/modules/goal/persistence/goal.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { GoalSeedService } from './goal-seed.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      GoalEntity,
      WorkspaceEntity,
      WorkspaceUserEntity,
    ]),
  ],
  providers: [GoalSeedService],
  exports: [GoalSeedService],
})
export class GoalSeedModule {}
