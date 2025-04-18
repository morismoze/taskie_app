import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WorkspaceUser } from './workspace-user.entity';
import { WorkspaceUserRepository } from './workspace-user.repository';

@Module({
  imports: [TypeOrmModule.forFeature([WorkspaceUser])],
  providers: [WorkspaceUserRepository],
  exports: [WorkspaceUserRepository],
})
export class WorkspaceUserPersistenceModule {}
