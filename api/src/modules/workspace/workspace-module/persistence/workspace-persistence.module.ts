import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WorkspaceUserPersistenceModule } from '../../workspace-user-module/persistence/workspace-user-persistence.module';
import { WorkspaceEntity } from './workspace.entity';
import { WorkspaceRepository } from './workspace.repository';
import { WorkspaceRepositoryImpl } from './workspace.repository.impl';

@Module({
  imports: [
    TypeOrmModule.forFeature([WorkspaceEntity]),
    WorkspaceUserPersistenceModule,
  ],
  providers: [
    {
      provide: WorkspaceRepository,
      useClass: WorkspaceRepositoryImpl,
    },
  ],
  exports: [WorkspaceRepository],
})
export class WorkspacePersistenceModule {}
