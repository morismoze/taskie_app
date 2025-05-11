import { Module } from '@nestjs/common';
import { WorkspaceUserModule } from '../workspace-user-module/workspace-user.module';
import { WorkspaceInviteCleanupService } from './cron/workspace-invite-cleanup.cron';
import { WorkspaceInvitePersistenceModule } from './persistence/workspace-invite-persistence.module';
import { WorkspaceInviteService } from './workspace-invite.service';

@Module({
  imports: [WorkspaceInvitePersistenceModule, WorkspaceUserModule],
  providers: [WorkspaceInviteService, WorkspaceInviteCleanupService],
  exports: [WorkspaceInviteService],
})
export class WorkspaceInviteModule {}
