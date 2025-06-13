import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { WorkspaceUserSeedService } from './workspace-user-seed.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      WorkspaceUserEntity,
      WorkspaceEntity,
      UserEntity,
    ]),
  ],
  providers: [WorkspaceUserSeedService],
  exports: [WorkspaceUserSeedService],
})
export class WorkspaceUserSeedModule {}
