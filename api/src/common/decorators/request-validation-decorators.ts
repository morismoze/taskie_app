import { applyDecorators } from '@nestjs/common';
import { Type } from 'class-transformer';
import {
  IsDate,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  Length,
  Max,
  MaxLength,
  Min,
  MinDate,
  Validate,
} from 'class-validator';
import {
  TASK_REWARD_POINTS_MAXIMAL,
  TASK_REWARD_POINTS_MINIMAL,
  TASK_REWARD_POINTS_STEP,
} from 'src/modules/task/task-module/domain/reward-points.domain';
import { IsMultipleOfConstraint } from '../validators/is-multiple-of.validator';

export const IsValidPersonName = () => {
  const decorators = [IsNotEmpty(), IsString(), Length(2, 50)];
  return applyDecorators(...decorators);
};

export const IsValidTaskTitle = () => {
  const decorators = [IsNotEmpty(), IsString()];
  return applyDecorators(...decorators);
};

export const IsValidTaskDescription = () => {
  const decorators = [IsNotEmpty(), IsString(), MaxLength(150)];
  return applyDecorators(...decorators);
};

export const IsValidTaskRewardPoints = () => {
  const decorators = [
    IsNotEmpty(),
    Type(() => Number),
    IsInt(),
    Min(TASK_REWARD_POINTS_MINIMAL),
    Max(TASK_REWARD_POINTS_MAXIMAL),
    Validate(IsMultipleOfConstraint, [TASK_REWARD_POINTS_STEP]),
  ];
  return applyDecorators(...decorators);
};

export const IsValidTaskDueDate = () => {
  const decorators = [Type(() => Date), IsDate(), MinDate(new Date())];
  return applyDecorators(...decorators);
};
