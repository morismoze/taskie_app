interface WorkspacePreviewDto {
  id: string;
  name: string;
  description: string | null;
  pictureUrl: string | null;
}

export type WorkspacesPreviewsResponse = WorkspacePreviewDto[];
