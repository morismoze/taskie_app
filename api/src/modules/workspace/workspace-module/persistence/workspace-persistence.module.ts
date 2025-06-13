import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UnitOfWorkModule } from 'src/modules/unit-of-work/unit-of-work.module';
import { WorkspaceEntity } from './workspace.entity';
import { WorkspaceRepository } from './workspace.repository';
import { WorkspaceRepositoryImpl } from './workspace.repository.impl';

@Module({
  imports: [TypeOrmModule.forFeature([WorkspaceEntity]), UnitOfWorkModule],
  providers: [
    {
      provide: WorkspaceRepository,
      useClass: WorkspaceRepositoryImpl,
    },
  ],
  exports: [WorkspaceRepository],
})
export class WorkspacePersistenceModule {}
