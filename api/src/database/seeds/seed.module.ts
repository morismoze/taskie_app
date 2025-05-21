import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import appConfig from 'src/config/app.config';
import { DatabaseModule } from 'src/modules/database/database.module';
import databaseConfig from '../config/database.config';
import { GoalSeedModule } from './goal/goal-seed.module';
import { TaskAssignmentSeedModule } from './task/task-assignment/task-assignment-seed.module';
import { TaskSeedModule } from './task/task-seed.module';
import { UserSeedModule } from './user/user-seed.module';
import { WorkspaceSeedModule } from './workspace/workspace-seed.module';
import { WorkspaceUserSeedModule } from './workspace/workspace-user/workspace-user-seed.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [databaseConfig, appConfig],
      envFilePath: ['.env'],
    }),
    DatabaseModule,
    UserSeedModule,
    WorkspaceSeedModule,
    WorkspaceUserSeedModule,
    TaskSeedModule,
    TaskAssignmentSeedModule,
    GoalSeedModule,
  ],
})
export class SeedModule {}
