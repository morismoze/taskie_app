import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

interface WorkspaceGoal {
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
}

export interface WorkspaceGoalsResponse {
  data: WorkspaceGoal[];
  total: number;
}
