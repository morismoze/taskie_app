import { Module } from '@nestjs/common';
import { WorkspaceInvitePersistenceModule } from './persistence/workspace-invite-persistence.module';
import { WorkspaceInviteService } from './workspace-invite.service';

@Module({
  imports: [WorkspaceInvitePersistenceModule],
  providers: [WorkspaceInviteService],
  exports: [WorkspaceInviteService],
})
export class WorkspaceInviteModule {}
