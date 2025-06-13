import { TransformFnParams } from 'class-transformer/types/interfaces';
import { Maybe } from '../types/maybe.type';

export const lowerCaseTransformer = (
  params: TransformFnParams,
): Maybe<string> => params.value?.toLowerCase().trim();
