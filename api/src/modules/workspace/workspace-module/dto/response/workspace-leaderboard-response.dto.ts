import { ApiProperty } from '@nestjs/swagger';

export class WorkspaceLeaderboardResponse {
  @ApiProperty({ description: 'WorkspaceUser ID', format: 'uuid' })
  id!: string;

  @ApiProperty()
  firstName!: string;

  @ApiProperty()
  lastName!: string;

  @ApiProperty({ type: String, nullable: true })
  profileImageUrl!: string | null;

  @ApiProperty()
  accumulatedPoints!: number;

  @ApiProperty()
  completedTasks!: number;
}
