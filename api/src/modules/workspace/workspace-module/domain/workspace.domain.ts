import { Goal } from 'src/modules/task/goal-module/domain/goal.domain';
import { Task } from 'src/modules/task/task-module/domain/task.domain';
import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceUser } from '../../workspace-user-module/domain/workspace-user.domain';

export interface Workspace {
  id: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
  ownedBy: User;
  goals: Goal[];
  members: WorkspaceUser[];
  name: string;
  description: string | null;
  pictureUrl: string | null;
  standaloneTasks: Task[];
}
