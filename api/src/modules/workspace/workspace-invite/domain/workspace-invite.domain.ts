import { RootDomain } from 'src/modules/database/domain/root.domain';
import { User } from 'src/modules/user/domain/user.domain';
import { Workspace } from '../../workspace-module/domain/workspace.domain';
import { WorkspaceUser } from '../../workspace-user-module/domain/workspace-user.domain';
import { WorkspaceInviteStatus } from './workspace-invite-status.enum';

export interface WorkspaceInvite extends RootDomain {
  workspace: Workspace;
  token: string;
  expiresAt: Date;
  createdBy: WorkspaceUser;
  usedBy: User;
  status: WorkspaceInviteStatus;
}
