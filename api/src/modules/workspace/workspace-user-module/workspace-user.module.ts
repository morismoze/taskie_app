import { Module } from '@nestjs/common';
import { WorkspaceUserPersistenceModule } from './persistence/workspace-user-persistence.module';
import { WorkspaceUserService } from './workspace-user.service';

@Module({
  imports: [WorkspaceUserPersistenceModule],
  providers: [WorkspaceUserService],
  exports: [WorkspaceUserService],
})
export class WorkspaceUserModule {}
