import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { WorkspaceSeedService } from './workspace-seed.service';

@Module({
  imports: [TypeOrmModule.forFeature([WorkspaceEntity, UserEntity])],
  providers: [WorkspaceSeedService],
  exports: [WorkspaceSeedService],
})
export class WorkspaceSeedModule {}
