import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceUser } from '../../workspace-user-module/domain/workspace-user.domain';

export interface Workspace {
  id: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
  ownedBy: {
    id: string;
  };
  goals: {
    id: string;
  }[];
  members: WorkspaceUser[];
  name: string;
  description: string | null;
  pictureUrl: string | null;
  standaloneTasks: {
    id: string;
  }[];
}
