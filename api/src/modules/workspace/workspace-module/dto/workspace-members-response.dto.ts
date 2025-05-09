export interface WorkspaceUserResponse {
  id: string;
  firstName: string;
  lastName: string;
  profileImageUrl: string | null;
}

export type WorkspaceUsersResponse = WorkspaceUserResponse[];
