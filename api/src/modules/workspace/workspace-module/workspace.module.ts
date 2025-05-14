import { Module } from '@nestjs/common';
import { GoalModule } from 'src/modules/goal/goal.module';
import { TaskAssignmentModule } from 'src/modules/task/task-assignment/task-assignment.module';
import { TaskModule } from 'src/modules/task/task-module/task.module';
import { UnitOfWorkModule } from 'src/modules/unit-of-work/unit-of-work.module';
import { UserModule } from 'src/modules/user/user.module';
import { WorkspaceInviteModule } from '../workspace-invite/workspace-invite.module';
import { WorkspaceUserModule } from '../workspace-user-module/workspace-user.module';
import { WorkspaceMembershipGuard } from './guards/workspace-membership.guard';
import { WorkspaceRoleGuard } from './guards/workspace-role.guard';
import { WorkspacePersistenceModule } from './persistence/workspace-persistence.module';
import { WorkspaceController } from './workspace.controller';
import { WorkspaceService } from './workspace.service';

@Module({
  imports: [
    WorkspacePersistenceModule,
    WorkspaceUserModule,
    UserModule,
    GoalModule,
    TaskModule,
    TaskAssignmentModule,
    WorkspaceInviteModule,
    UnitOfWorkModule,
  ],
  controllers: [WorkspaceController],
  providers: [WorkspaceService, WorkspaceRoleGuard, WorkspaceMembershipGuard],
})
export class WorkspaceModule {}
