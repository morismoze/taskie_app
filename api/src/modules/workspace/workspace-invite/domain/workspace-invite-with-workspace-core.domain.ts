import { WorkspaceCore } from '../../workspace-module/domain/workspace-core.domain';
import { WorkspaceInviteCore } from './workspace-invite-core.domain';

export interface WorkspaceInviteWithWorkspaceCore extends WorkspaceInviteCore {
  workspace: WorkspaceCore;
}
