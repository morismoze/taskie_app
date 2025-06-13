import { NestFactory } from '@nestjs/core';
import { GoalSeedService } from './goal/goal-seed.service';
import { SeedModule } from './seed.module';
import { TaskAssignmentSeedService } from './task/task-assignment/task-assignment-seed.service';
import { TaskSeedService } from './task/task-seed.service';
import { UserSeedService } from './user/user-seed.service';
import { WorkspaceSeedService } from './workspace/workspace-seed.service';
import { WorkspaceUserSeedService } from './workspace/workspace-user/workspace-user-seed.service';

const runSeed = async () => {
  const app = await NestFactory.create(SeedModule);

  await app.get(UserSeedService).run();
  await app.get(WorkspaceSeedService).run();
  await app.get(WorkspaceUserSeedService).run();
  await app.get(TaskSeedService).run();
  await app.get(TaskAssignmentSeedService).run();
  await app.get(GoalSeedService).run();

  await app.close();
};

void runSeed();
