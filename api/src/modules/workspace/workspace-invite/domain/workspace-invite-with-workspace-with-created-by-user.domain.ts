import { WorkspaceWithCreatedByUser } from '../../workspace-module/domain/workspace-with-created-by-user.domain';
import { WorkspaceInviteCore } from './workspace-invite-core.domain';

export interface WorkspaceInviteWithWorkspaceWithCreatedByUser
  extends WorkspaceInviteCore {
  workspace: WorkspaceWithCreatedByUser;
}
