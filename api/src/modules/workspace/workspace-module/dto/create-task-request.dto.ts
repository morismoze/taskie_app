import { Type } from 'class-transformer';
import {
  IsArray,
  IsDate,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  Min,
  Validate,
} from 'class-validator';
import { IsMultipleOfConstraint } from 'src/common/validators/is-multiple-of.validator';

export class CreateTaskRequest {
  @IsNotEmpty()
  @IsString()
  title: string;

  @IsOptional()
  @IsString()
  description: string | null;

  @IsNotEmpty()
  @IsNumber()
  @Min(0)
  @Max(50)
  @Validate(IsMultipleOfConstraint, [5])
  rewardPoints: number;

  @IsOptional()
  @Type(() => Date)
  @IsDate()
  dueDate: Date | null;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  assignees: string[]; // Array of WorkspaceUser IDs

  constructor(
    title: string,
    rewardPoints: number,
    description?: string | null,
    dueDate?: Date | null,
    assignees?: string[],
  ) {
    this.title = title;
    this.rewardPoints = rewardPoints;
    this.description = description ?? null;
    this.dueDate = dueDate ?? null;
    this.assignees = assignees ?? [];
  }
}
