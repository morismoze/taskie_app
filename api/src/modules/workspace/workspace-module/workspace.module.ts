import { forwardRef, Module } from '@nestjs/common';
import { GoalModule } from 'src/modules/goal/goal.module';
import { SessionModule } from 'src/modules/session/session.module';
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
    // Mirroring WorkspaceModule import in the UserModule
    forwardRef(() => UserModule),
    GoalModule,
    TaskModule,
    TaskAssignmentModule,
    WorkspaceInviteModule,
    UnitOfWorkModule,
    SessionModule,
  ],
  controllers: [WorkspaceController],
  providers: [WorkspaceService, WorkspaceRoleGuard, WorkspaceMembershipGuard],
  exports: [WorkspaceService],
})
export class WorkspaceModule {}
