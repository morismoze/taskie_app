import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsEnum, IsInt, IsOptional, IsString, Min } from 'class-validator';
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
    default: WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  limit?: number;

  @ApiPropertyOptional({
    enum: ProgressStatus,
  })
  @IsOptional()
  @IsEnum(ProgressStatus)
  status?: ProgressStatus;

  @ApiPropertyOptional({
    type: String,
    description: 'Search by title - THIS IS NOT YET IMPLEMENTED',
    example: 'design',
  })
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({
    enum: SortBy,
  })
  @IsOptional()
  @IsEnum(SortBy)
  sort?: SortBy;

  constructor(
    page?: number,
    limit?: number,
    status?: ProgressStatus,
    search?: string,
    sort?: SortBy,
  ) {
    this.page = page;
    this.limit = limit;
    this.status = status;
    this.search = search;
    this.sort = sort;
  }
}
