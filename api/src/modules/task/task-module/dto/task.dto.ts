export interface TaskDto {
  id: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
  assignees: WorkspaceUser[];
  createdBy: WorkspaceUser;
  description: string | null;
  reward: string | null;
  goal: Goal | null;
  rewardPoints: number;
  status: ProgressStatus;
  title: string;
  workspace: Workspace;
}
