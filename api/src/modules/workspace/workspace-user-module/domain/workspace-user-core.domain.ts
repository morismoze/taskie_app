import { RootDomain } from 'src/modules/database/domain/root.domain';
import { WorkspaceUserRole } from './workspace-user-role.enum';

export interface WorkspaceUserCore extends RootDomain {
  workspaceRole: WorkspaceUserRole;
}
