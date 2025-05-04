interface WorkspaceUser {
  id: string;
  firstName: string;
  lastName: string;
  profileImageUrl: string | null;
}

export type WorkspaceMembersResponse = WorkspaceUser[];
