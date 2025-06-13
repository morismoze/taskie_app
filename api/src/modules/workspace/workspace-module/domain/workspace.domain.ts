import { RootDomain } from 'src/modules/database/domain/root.domain';
import { Goal } from 'src/modules/goal/domain/goal.domain';
import { Task } from 'src/modules/task/task-module/domain/task.domain';
import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceUser } from '../../workspace-user-module/domain/workspace-user.domain';

export interface Workspace extends RootDomain {
  createdBy: User | null;
  goals: Goal[];
  members: WorkspaceUser[];
  name: string;
  description: string | null;
  tasks: Task[];
  pictureUrl: string | null;
}
