import { RootDomain } from 'src/modules/database/domain/root.domain';
import { Workspace } from 'src/modules/workspace/workspace-module/domain/workspace.domain';
import { WorkspaceUser } from 'src/modules/workspace/workspace-user-module/domain/workspace-user.domain';
import { Goal } from '../../goal-module/domain/goal.domain';
import { TaskAssignment } from '../../task-assignment/domain/task-assignment.domain';

export interface Task extends RootDomain {
  workspace: Workspace;
  title: string;
  rewardPoints: number;
  description: string | null;
  optionalReward: string | null;
  goals: Goal[] | null;
  taskAssignments: TaskAssignment[];
  createdBy: WorkspaceUser;
}
