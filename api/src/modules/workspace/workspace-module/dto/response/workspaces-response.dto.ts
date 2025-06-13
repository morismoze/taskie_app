export interface WorkspaceResponse {
  id: string;
  name: string;
  description: string | null;
  pictureUrl: string | null;
}

export type WorkspacesResponse = WorkspaceResponse[];
