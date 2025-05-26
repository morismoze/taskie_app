import { applyDecorators } from '@nestjs/common';
import { IsNotEmpty, IsOptional, IsString, Length } from 'class-validator';

export const IsValidPersonName = ({ required }: { required: boolean }) => {
  const decorators = [IsString(), Length(2, 50)];
  decorators.unshift(required ? IsNotEmpty() : IsOptional());
  return applyDecorators(...decorators);
};
