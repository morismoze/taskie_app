import { WorkspaceUserCore } from './workspace-user-core.domain';

export interface WorkspaceUserWithCreatedByUser extends WorkspaceUserCore {
  // Will be null in the case workspace user was the one
  // who created the workspace
  createdBy: {
    id: string; // workspace user ID
    firstName: string;
    lastName: string;
    profileImageUrl: string | null;
  } | null;
}
