import { RootDomain } from 'src/modules/database/domain/root.domain';
import { Goal } from 'src/modules/goal/domain/goal.domain';
import { TaskAssignment } from 'src/modules/task/task-assignment/domain/task-assignment.domain';
import { User } from 'src/modules/user/domain/user.domain';
import { Workspace } from '../../workspace-module/domain/workspace.domain';
import { WorkspaceUserRole } from './workspace-user-role.enum';

export interface WorkspaceUser extends RootDomain {
  workspace: Workspace;
  user: User;
  workspaceRole: WorkspaceUserRole;
  createdBy: WorkspaceUser | null;
  goals: Goal[];
  taskAssignments: TaskAssignment[];
}
