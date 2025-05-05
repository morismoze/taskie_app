import { Workspace } from '../../workspace-module/domain/workspace.domain';
import { WorkspaceUserCore } from './workspace-user-core.domain';

export interface WorkspaceUserWithWorkspace extends WorkspaceUserCore {
  workspace: Workspace;
}
