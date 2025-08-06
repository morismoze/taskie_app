import { Type } from 'class-transformer';
import { IsEnum, IsInt, IsOptional, IsString, Min } from 'class-validator';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export enum SortBy {
  NEWEST = 'newest',
  OLDEST = 'oldest',
}

const WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT = 20;

export class WorkspaceObjectiveRequestQuery {
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  limit: number;

  @IsOptional()
  @IsEnum(ProgressStatus)
  status: ProgressStatus | null;

  @IsOptional()
  @IsString()
  search: string | null;

  @IsOptional()
  @IsEnum(SortBy)
  sort: SortBy | null;

  constructor(
    page?: number,
    limit?: number,
    status?: ProgressStatus,
    search?: string,
    sort?: SortBy,
  ) {
    this.page = page ? page : 1;
    this.limit = limit ? limit : WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT;
    this.status = status ? status : null;
    this.search = search ? search : null;
    this.sort = sort ? sort : null;
  }
}
