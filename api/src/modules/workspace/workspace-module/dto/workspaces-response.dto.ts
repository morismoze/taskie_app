interface Workspace {
  id: string;
  name: string;
  description: string | null;
  pictureUrl: string | null;
}

export type WorkspacesResponse = Workspace[];
