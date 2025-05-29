import { applyDecorators } from '@nestjs/common';
import { Type } from 'class-transformer';
import {
  IsDate,
  IsInt,
  IsNotEmpty,
  IsString,
  IsUUID,
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
} from 'src/modules/task/task-module/domain/task.constants';
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

export const IsValidGoalTitle = () => {
  const decorators = [IsNotEmpty(), IsString()];
  return applyDecorators(...decorators);
};

export const IsValidGoalDescription = () => {
  const decorators = [IsNotEmpty(), IsString(), MaxLength(150)];
  return applyDecorators(...decorators);
};

export const IsValidGoalRequiredPoints = () => {
  const decorators = [
    IsNotEmpty(),
    Type(() => Number),
    IsInt(),
    Min(TASK_REWARD_POINTS_MINIMAL),
    Max(1000000), // This is trying to define a reasonable upper limit
    Validate(IsMultipleOfConstraint, [TASK_REWARD_POINTS_STEP]),
  ];
  return applyDecorators(...decorators);
};

export const IsValidGoalAssignee = () => {
  const decorators = [IsNotEmpty(), IsUUID()];
  return applyDecorators(...decorators);
};
