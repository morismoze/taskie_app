import { RootDomain } from 'src/modules/database/domain/root.domain';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export interface GoalCore extends RootDomain {
  title: string;
  description: string | null;
  requiredPoints: number;
  status: ProgressStatus;
}
