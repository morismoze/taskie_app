import { Paginable } from 'src/common/types/paginable.type';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export interface WorkspaceTaskResponse {
  id: string;
  title: string;
  description: string | null;
  dueDate: string | null;
  rewardPoints: number;
  assignees: {
    id: string;
    firstName: string;
    lastName: string;
    profileImageUrl: string | null;
    status: ProgressStatus;
  }[];
  // Will be null in the case user has deleted their account
  createdBy: {
    id: string;
    firstName: string;
    lastName: string;
    profileImageUrl: string | null;
  } | null;
  createdAt: string;
}

export type WorkspaceTasksResponse = Paginable<WorkspaceTaskResponse>;
