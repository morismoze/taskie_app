import { ProgressStatus } from './progress-status.enum';
import { TaskCore } from './task-core.domain';

export interface TaskWithAssigneesCore extends TaskCore {
  assignees: {
    id: string; // workspace user ID
    firstName: string;
    lastName: string;
    profileImageUrl: string | null;
    status: ProgressStatus; // task progress status for that specific user
  }[];
}
