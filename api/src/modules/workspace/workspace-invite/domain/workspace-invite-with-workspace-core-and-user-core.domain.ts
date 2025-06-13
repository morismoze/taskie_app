import { WorkspaceCore } from '../../workspace-module/domain/workspace-core.domain';
import { WorkspaceUserCore } from '../../workspace-user-module/domain/workspace-user-core.domain';
import { WorkspaceInviteCore } from './workspace-invite-core.domain';

export interface WorkspaceInviteWithWorkspaceCoreAndCreatedByUserCoreAndUsedByWorkspaceUserCore
  extends WorkspaceInviteCore {
  workspace: WorkspaceCore;
  createdBy: WorkspaceUserCore | null;
  usedBy: WorkspaceUserCore | null;
}
