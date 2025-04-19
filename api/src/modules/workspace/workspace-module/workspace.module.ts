import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { WorkspaceRoleGuard } from '../guards/workspace-role.guard';
import { WorkspacePersistenceModule } from './persistence/workspace-persistence.module';
import { WorkspaceService } from './workspace.service';

@Module({
  imports: [PassportModule, WorkspacePersistenceModule],
  providers: [WorkspaceService, WorkspaceRoleGuard],
})
export class WorkspaceModule {}
