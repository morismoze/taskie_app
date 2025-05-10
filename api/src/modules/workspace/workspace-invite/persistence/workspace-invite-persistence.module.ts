import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WorkspaceInviteEntity } from './workspace-invite.entity';
import { WorkspaceInviteRepository } from './workspace-invite.repository';
import { WorkspaceInviteRepositoryImpl } from './workspace-invite.repository.impl';

@Module({
  imports: [TypeOrmModule.forFeature([WorkspaceInviteEntity])],
  providers: [
    {
      provide: WorkspaceInviteRepository,
      useClass: WorkspaceInviteRepositoryImpl,
    },
  ],
  exports: [WorkspaceInviteRepository],
})
export class WorkspaceInvitePersistenceModule {}
