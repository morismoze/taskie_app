import { Module } from '@nestjs/common';
import { WorkspaceUserModule } from '../workspace-user-module/workspace-user.module';
import { WorkspaceInvitePersistenceModule } from './persistence/workspace-invite-persistence.module';
import { WorkspaceInviteService } from './workspace-invite.service';

@Module({
  imports: [WorkspaceInvitePersistenceModule, WorkspaceUserModule],
  providers: [WorkspaceInviteService],
  exports: [WorkspaceInviteService],
})
export class WorkspaceInviteModule {}
