import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UnitOfWorkModule } from 'src/modules/unit-of-work/unit-of-work.module';
import { TransactionalWorkspaceInviteRepository } from './transactional/transactional-workspace-invite.repository';
import { TransactionalWorkspaceInviteRepositoryImpl } from './transactional/transactional-workspace-invite.repository.impl';
import { WorkspaceInviteEntity } from './workspace-invite.entity';
import { WorkspaceInviteRepository } from './workspace-invite.repository';
import { WorkspaceInviteRepositoryImpl } from './workspace-invite.repository.impl';

@Module({
  imports: [
    TypeOrmModule.forFeature([WorkspaceInviteEntity]),
    UnitOfWorkModule,
  ],
  providers: [
    {
      provide: WorkspaceInviteRepository,
      useClass: WorkspaceInviteRepositoryImpl,
    },
    {
      provide: TransactionalWorkspaceInviteRepository,
      useClass: TransactionalWorkspaceInviteRepositoryImpl,
    },
  ],
  exports: [WorkspaceInviteRepository, TransactionalWorkspaceInviteRepository],
})
export class WorkspaceInvitePersistenceModule {}
