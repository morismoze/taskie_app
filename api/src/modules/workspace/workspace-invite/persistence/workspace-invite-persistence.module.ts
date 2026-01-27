import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UnitOfWorkModule } from 'src/modules/unit-of-work/unit-of-work.module';
import { NonTransactionalWorkspaceInviteRepository } from './non-transactional/non-transactional-workspace-invite.repository';
import { NonTransactionalWorkspaceInviteRepositoryImpl } from './non-transactional/non-transactional-workspace-invite.repository.impl';

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
      provide: NonTransactionalWorkspaceInviteRepository,
      useClass: NonTransactionalWorkspaceInviteRepositoryImpl,
    },
    {
      provide: WorkspaceInviteRepository,
      useClass: WorkspaceInviteRepositoryImpl,
    },
  ],
  exports: [
    NonTransactionalWorkspaceInviteRepository,
    WorkspaceInviteRepository,
  ],
})
export class WorkspaceInvitePersistenceModule {}
