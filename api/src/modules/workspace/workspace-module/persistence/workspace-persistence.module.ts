import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WorkspaceEntity } from './workspace.entity';
import { WorkspaceRepository } from './workspace.repository';
import { WorkspaceRepositoryImpl } from './workspace.repository.impl';

@Module({
  imports: [TypeOrmModule.forFeature([WorkspaceEntity])],
  providers: [
    {
      provide: WorkspaceRepository,
      useClass: WorkspaceRepositoryImpl,
    },
  ],
  exports: [WorkspaceRepository],
})
export class WorkspacePersistenceModule {}
