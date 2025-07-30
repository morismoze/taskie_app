import { RootDomain } from 'src/modules/database/domain/root.domain';
import { Workspace } from '../../workspace-module/domain/workspace.domain';
import { WorkspaceUser } from '../../workspace-user-module/domain/workspace-user.domain';

export interface WorkspaceInvite extends RootDomain {
  workspace: Workspace;
  token: string;
  expiresAt: Date;
  createdBy: WorkspaceUser | null;
  usedBy: WorkspaceUser | null;
}
