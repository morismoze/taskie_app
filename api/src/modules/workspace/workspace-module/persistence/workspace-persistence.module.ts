import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Workspace } from './workspace.entity';
import { WorkspaceRepository } from './workspace.repository';

@Module({
  imports: [TypeOrmModule.forFeature([Workspace])],
  providers: [WorkspaceRepository],
  exports: [WorkspaceRepository],
})
export class WorkspacePersistenceModule {}
