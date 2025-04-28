import { WorkspaceUserDto } from 'src/modules/workspace/workspace-user-module/dto/workspace-user.dto';
import { ProgressStatus } from '../domain/progress-status.enum';

export interface TaskDto {
  id: string;
  title: string;
  rewardPoints: number;
  description: string | null;
  goalId: string | null;
  createdBy: WorkspaceUserDto;
  assignees: WorkspaceUserDto[];
  createdAt: Date;
  updatedAt: Date;
  status: ProgressStatus;
}
