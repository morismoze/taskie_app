import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { GoalModule } from 'src/modules/goal/goal.module';
import { TaskModule } from 'src/modules/task/task-module/task.module';
import { UserModule } from 'src/modules/user/user.module';
import { WorkspaceMembershipGuard } from './guards/workspace-membership.guard';
import { WorkspaceRoleGuard } from './guards/workspace-role.guard';
import { WorkspacePersistenceModule } from './persistence/workspace-persistence.module';
import { WorkspaceController } from './workspace.controller';
import { WorkspaceService } from './workspace.service';

@Module({
  imports: [
    PassportModule,
    WorkspacePersistenceModule,
    UserModule,
    GoalModule,
    TaskModule,
  ],
  controllers: [WorkspaceController],
  providers: [WorkspaceService, WorkspaceRoleGuard, WorkspaceMembershipGuard],
})
export class WorkspaceModule {}
