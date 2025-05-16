import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export interface WorkspaceTaskResponse {
  id: string;
  title: string;
  rewardPoints: number;
  assignees: {
    id: string;
    firstName: string;
    lastName: string;
    profileImageUrl: string | null;
    status: ProgressStatus;
  }[];
}

export interface WorkspaceTasksResponse {
  data: WorkspaceTaskResponse[];
  total: number;
}
