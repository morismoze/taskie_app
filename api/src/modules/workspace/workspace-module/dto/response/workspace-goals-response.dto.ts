import { Paginable } from 'src/common/types/paginable.type';
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
  description: string | null;
  requiredPoints: number;
  status: ProgressStatus;
  accumulatedPoints: number;
}

export type WorkspaceGoalsResponse = Paginable<WorkspaceGoalResponse>;
