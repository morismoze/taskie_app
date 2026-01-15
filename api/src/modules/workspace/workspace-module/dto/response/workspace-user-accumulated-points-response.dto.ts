import { ApiProperty } from '@nestjs/swagger';

export class WorkspaceUserAccumulatedPointsResponse {
  @ApiProperty()
  accumulatedPoints!: number;
}
