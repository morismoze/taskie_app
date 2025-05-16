import { WorkspaceCore } from '../../workspace-module/domain/workspace-core.domain';
import { WorkspaceUserCore } from './workspace-user-core.domain';

export interface WorkspaceUserWithWorkspaceCore extends WorkspaceUserCore {
  workspace: WorkspaceCore;
}
