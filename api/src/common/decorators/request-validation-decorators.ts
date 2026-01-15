import { applyDecorators } from '@nestjs/common';
import { Type } from 'class-transformer';
import {
  IsDateString,
  IsInt,
  IsNotEmpty,
  IsString,
  IsUUID,
  Length,
  Max,
  MaxLength,
  Min,
  Validate,
} from 'class-validator';
import { GOAL_REQUIRED_POINTS_MAXIMAL } from 'src/modules/goal/domain/goal.constants';
import {
  TASK_REWARD_POINTS_MAXIMAL,
  TASK_REWARD_POINTS_MINIMAL,
  TASK_REWARD_POINTS_STEP,
} from 'src/modules/task/task-module/domain/task.constants';
import {
  OBJECTIVE_DESCRIPTION_MAX_CHARS,
  OBJECTIVE_NAME_MAX_CHARS,
  OBJECTIVE_NAME_MIN_CHARS,
  PERSON_NAME_MAX_CHARS,
  PERSON_NAME_MIN_CHARS,
  WORKSPACE_DESCRIPTION_MAX_CHARS,
  WORKSPACE_NAME_MAX_CHARS,
  WORKSPACE_NAME_MIN_CHARS,
} from '../helper/constants';
import { IsMultipleOfConstraint } from '../validators/is-multiple-of.validator';
import { IsNotPastIsoDateConstraint } from '../validators/is-not-past-date.validator';

export const IsValidWorkspaceName = () => {
  const decorators = [
    IsNotEmpty(),
    IsString(),
    Length(WORKSPACE_NAME_MIN_CHARS, WORKSPACE_NAME_MAX_CHARS),
  ];
  return applyDecorators(...decorators);
};

export const IsValidWorkspaceDescription = () => {
  const decorators = [
    IsNotEmpty(),
    IsString(),
    MaxLength(WORKSPACE_DESCRIPTION_MAX_CHARS),
  ];
  return applyDecorators(...decorators);
};

export const IsValidPersonName = () => {
  const decorators = [
    IsNotEmpty(),
    IsString(),
    Length(PERSON_NAME_MIN_CHARS, PERSON_NAME_MAX_CHARS),
  ];
  return applyDecorators(...decorators);
};

export const IsValidTaskTitle = () => {
  const decorators = [
    IsNotEmpty(),
    IsString(),
    Length(OBJECTIVE_NAME_MIN_CHARS, OBJECTIVE_NAME_MAX_CHARS),
  ];
  return applyDecorators(...decorators);
};

export const IsValidTaskDescription = () => {
  const decorators = [
    IsNotEmpty(),
    IsString(),
    MaxLength(OBJECTIVE_DESCRIPTION_MAX_CHARS),
  ];
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
  const decorators = [IsDateString(), Validate(IsNotPastIsoDateConstraint)];
  return applyDecorators(...decorators);
};

export const IsValidGoalTitle = () => {
  const decorators = [
    IsNotEmpty(),
    IsString(),
    Length(OBJECTIVE_NAME_MIN_CHARS, OBJECTIVE_NAME_MAX_CHARS),
  ];
  return applyDecorators(...decorators);
};

export const IsValidGoalDescription = () => {
  const decorators = [
    IsNotEmpty(),
    IsString(),
    MaxLength(OBJECTIVE_DESCRIPTION_MAX_CHARS),
  ];
  return applyDecorators(...decorators);
};

export const IsValidGoalRequiredPoints = () => {
  const decorators = [
    IsNotEmpty(),
    Type(() => Number),
    IsInt(),
    Min(TASK_REWARD_POINTS_MINIMAL),
    Max(GOAL_REQUIRED_POINTS_MAXIMAL), // This is trying to define a reasonable upper limit
    Validate(IsMultipleOfConstraint, [TASK_REWARD_POINTS_STEP]),
  ];
  return applyDecorators(...decorators);
};

export const IsValidGoalAssignee = () => {
  const decorators = [IsNotEmpty(), IsUUID()];
  return applyDecorators(...decorators);
};
