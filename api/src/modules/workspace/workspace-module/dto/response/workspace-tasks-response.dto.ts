import { ApiProperty } from '@nestjs/swagger';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export class WorkspaceTaskAssigneeResponse {
  @ApiProperty()
  id!: string;

  @ApiProperty()
  firstName!: string;

  @ApiProperty()
  lastName!: string;

  @ApiProperty({ type: String, nullable: true })
  profileImageUrl!: string | null;

  @ApiProperty({ enum: ProgressStatus })
  status!: ProgressStatus;
}

export class WorkspaceTaskCreatedByResponse {
  @ApiProperty()
  id!: string;

  @ApiProperty()
  firstName!: string;

  @ApiProperty()
  lastName!: string;

  @ApiProperty({ type: String, nullable: true })
  profileImageUrl!: string | null;
}

export class WorkspaceTaskResponse {
  @ApiProperty()
  id!: string;

  @ApiProperty()
  title!: string;

  @ApiProperty({ type: String, nullable: true })
  description!: string | null;

  @ApiProperty({ type: String, nullable: true, format: 'date' })
  dueDate!: string | null;

  @ApiProperty()
  rewardPoints!: number;

  @ApiProperty({ type: () => WorkspaceTaskAssigneeResponse, isArray: true })
  assignees!: WorkspaceTaskAssigneeResponse[];

  @ApiProperty({
    description: 'Will be null in the case user has deleted their account',
    type: () => WorkspaceTaskCreatedByResponse,
    nullable: true,
  })
  createdBy!: WorkspaceTaskCreatedByResponse | null;

  @ApiProperty({ format: 'date-time' })
  createdAt!: string;
}

export class WorkspaceTasksResponse {
  @ApiProperty({ type: () => WorkspaceTaskResponse, isArray: true })
  items!: WorkspaceTaskResponse[];

  @ApiProperty()
  totalPages!: number;

  @ApiProperty()
  total!: number;
}
