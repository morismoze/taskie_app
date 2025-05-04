import { WorkspaceUserDto } from 'src/modules/workspace/workspace-user-module/dto/workspace-user.dto';

export interface TaskDto {
  title: string;
  rewardPoints: number;
  description: string | null;
  createdBy: {
    id: WorkspaceUserDto['id'];
    firstName: WorkspaceUserDto['user']['firstName'];
    lastName: WorkspaceUserDto['user']['lastName'];
    profileImageUrl: WorkspaceUserDto['user']['profileImageUrl'];
  };
  createdAt: Date;
  dueDate: Date | null;
}
