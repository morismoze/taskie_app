import { ApiProperty } from '@nestjs/swagger';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export class WorkspaceGoalAssigneeResponse {
  @ApiProperty({ description: 'WorkspaceUser ID' })
  id!: string;

  @ApiProperty()
  firstName!: string;

  @ApiProperty()
  lastName!: string;

  @ApiProperty({ type: String, nullable: true })
  profileImageUrl!: string | null;
}

export class WorkspaceGoalCreatedByResponse {
  @ApiProperty()
  id!: string;

  @ApiProperty()
  firstName!: string;

  @ApiProperty()
  lastName!: string;

  @ApiProperty({ type: String, nullable: true })
  profileImageUrl!: string | null;
}

export class WorkspaceGoalResponse {
  @ApiProperty()
  id!: string;

  @ApiProperty({ type: () => WorkspaceGoalAssigneeResponse })
  assignee!: WorkspaceGoalAssigneeResponse;

  @ApiProperty({
    description: 'Will be null in the case user has deleted their account',
    type: () => WorkspaceGoalCreatedByResponse,
    nullable: true,
  })
  createdBy!: WorkspaceGoalCreatedByResponse | null;

  @ApiProperty({ format: 'date-time' })
  createdAt!: string;

  @ApiProperty()
  title!: string;

  @ApiProperty({ nullable: true })
  description!: string | null;

  @ApiProperty()
  requiredPoints!: number;

  @ApiProperty({ enum: ProgressStatus })
  status!: ProgressStatus;

  @ApiProperty()
  accumulatedPoints!: number;
}

export class WorkspaceGoalsResponse {
  @ApiProperty({ type: () => WorkspaceGoalResponse, isArray: true })
  items!: WorkspaceGoalResponse[];

  @ApiProperty()
  totalPages!: number;

  @ApiProperty()
  total!: number;
}
