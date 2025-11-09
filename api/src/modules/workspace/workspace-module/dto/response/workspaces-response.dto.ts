export interface WorkspaceResponse {
  id: string;
  name: string;
  description: string | null;
  pictureUrl: string | null;
  createdAt: string;
  // Will be null in the case user has deleted their account
  createdBy: {
    id: string;
    firstName: string;
    lastName: string;
    profileImageUrl: string | null;
  } | null;
}

export type WorkspacesResponse = WorkspaceResponse[];
