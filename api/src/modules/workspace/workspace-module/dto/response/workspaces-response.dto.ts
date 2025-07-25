export interface WorkspaceResponse {
  id: string;
  name: string;
  description: string | null;
  pictureUrl: string | null;
  createdAt: string;
  // Will be null in the case user has deleted their account
  // and that user was the only Manager left in that workspace.
  createdBy: {
    firstName: string;
    lastName: string;
    profileImageUrl: string | null;
  } | null;
}

export type WorkspacesResponse = WorkspaceResponse[];
