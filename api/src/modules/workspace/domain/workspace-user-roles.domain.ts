import { WorkspaceUserRole } from './workspace-role.enum';

export type WorkspaceUserRolesDomain = {
  workspaceId: string;
  role: WorkspaceUserRole;
}[];
