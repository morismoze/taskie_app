import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsEnum, IsInt, IsOptional, Max, Min } from 'class-validator';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export enum SortBy {
  NEWEST = 'newest',
  OLDEST = 'oldest',
}

export const WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT = 20;

export class WorkspaceObjectiveRequestQuery {
  @ApiPropertyOptional({ type: Number, minimum: 1, default: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number;

  @ApiPropertyOptional({
    type: Number,
    minimum: 1,
    maximum: WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT,
    default: WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT)
  limit?: number;

  @ApiPropertyOptional({
    enum: ProgressStatus,
    description: 'Default - all statuses are returned',
  })
  @IsOptional()
  @IsEnum(ProgressStatus)
  status?: ProgressStatus;

  // Not yet fully, secure-wise implemented on the DB
  // @ApiPropertyOptional({
  //   type: String,
  //   description: 'Search by title - THIS IS NOT YET IMPLEMENTED',
  // })
  // @IsOptional()
  // @IsString()
  // search?: string;

  @ApiPropertyOptional({
    enum: SortBy,
    default: SortBy.NEWEST,
  })
  @IsOptional()
  @IsEnum(SortBy)
  sort?: SortBy;

  constructor(
    page?: number,
    limit?: number,
    status?: ProgressStatus,
    sort?: SortBy,
  ) {
    this.page = page;
    this.limit = limit;
    this.status = status;
    this.sort = sort;
  }
}
