import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export interface WorkspaceGoalResponse {
  id: string;
  assignee: {
    id: string;
    firstName: string;
    lastName: string;
    profileImageUrl: string | null;
  };
  title: string;
  requiredPoints: number;
  status: ProgressStatus;
  accumulatedPoints: number;
}

export interface WorkspaceGoalsResponse {
  data: WorkspaceGoalResponse[];
  total: number;
}
