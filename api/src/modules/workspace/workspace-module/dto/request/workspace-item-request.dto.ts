import { Type } from 'class-transformer';
import { IsEnum, IsInt, IsOptional, IsString, Min } from 'class-validator';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

export class WorkspaceItemRequestQuery {
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
  status: ProgressStatus;

  @IsOptional()
  @IsString()
  search: string | null;

  constructor(
    page?: number,
    limit?: number,
    status?: ProgressStatus,
    search?: string,
  ) {
    this.page = page !== undefined ? page : 1;
    this.limit = limit !== undefined ? limit : 20;
    this.status = status !== undefined ? status : ProgressStatus.IN_PROGRESS;
    this.search = search !== undefined ? search : null;
  }
}
