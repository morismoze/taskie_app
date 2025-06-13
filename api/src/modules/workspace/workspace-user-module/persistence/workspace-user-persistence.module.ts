import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UnitOfWorkModule } from 'src/modules/unit-of-work/unit-of-work.module';
import { WorkspaceUserEntity } from './workspace-user.entity';
import { WorkspaceUserRepository } from './workspace-user.repository';
import { WorkspaceUserRepositoryImpl } from './workspace-user.repository.impl';

@Module({
  imports: [TypeOrmModule.forFeature([WorkspaceUserEntity]), UnitOfWorkModule],
  providers: [
    {
      provide: WorkspaceUserRepository,
      useClass: WorkspaceUserRepositoryImpl,
    },
  ],
  exports: [WorkspaceUserRepository],
})
export class WorkspaceUserPersistenceModule {}
