import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WorkspaceUserPersistenceModule } from '../../workspace-user-module/persistence/workspace-user-persistence.module';
import { WorkspaceEntity } from './workspace.entity';
import { WorkspaceRepository } from './workspace.repository';

@Module({
  imports: [
    TypeOrmModule.forFeature([WorkspaceEntity]),
    WorkspaceUserPersistenceModule,
  ],
  providers: [WorkspaceRepository],
  exports: [WorkspaceRepository],
})
export class WorkspacePersistenceModule {}
