import { RootDomain } from 'src/modules/database/domain/root.domain';
import { ProgressStatus } from '../../task-module/domain/progress-status.enum';

export interface TaskAssignmentCore extends RootDomain {
  status: ProgressStatus;
}
