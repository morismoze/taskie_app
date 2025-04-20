import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WorkspaceUserService } from '../workspace-user.service';
import { WorkspaceUserEntity } from './workspace-user.entity';
import { WorkspaceUserRepository } from './workspace-user.repository';

@Module({
  imports: [TypeOrmModule.forFeature([WorkspaceUserEntity])],
  providers: [WorkspaceUserRepository],
  exports: [WorkspaceUserService],
})
export class WorkspaceUserPersistenceModule {}
