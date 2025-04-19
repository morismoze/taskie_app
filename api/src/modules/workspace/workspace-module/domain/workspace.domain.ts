import { Goal } from 'src/modules/task/goal-module/domain/goal.domain';
import { Task } from 'src/modules/task/task-module/persistence/task.entity';
import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceUser } from '../../workspace-user-module/persistence/workspace-user.entity';

export interface Workspace {
  id: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
  owner: User;
  goals: Goal[];
  members: WorkspaceUser[];
  name: string;
  standaloneTasks: Task[];
}
