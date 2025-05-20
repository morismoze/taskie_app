import { NestFactory } from '@nestjs/core';
import { SeedModule } from './seed.module';
import { UserSeedService } from './user/user-seed.service';
import { WorkspaceSeedService } from './workspace/workspace-seed.service';
import { WorkspaceUserSeedService } from './workspace/workspace-user/workspace-user-seed.service';

const runSeed = async () => {
  const app = await NestFactory.create(SeedModule);

  await app.get(UserSeedService).run();
  await app.get(WorkspaceSeedService).run();
  await app.get(WorkspaceUserSeedService).run();

  await app.close();
};

void runSeed();
