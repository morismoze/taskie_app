import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsString, ValidateIf } from 'class-validator';

export enum LogLevel {
  WARN = 'warn',
  ERROR = 'error',
  FATAL = 'fatal',
}

export class CreateMobileLogRequest {
  @ApiPropertyOptional()
  @ValidateIf((_, v) => v !== undefined) // Optional, but null is invalid
  @IsString()
  userId?: string;

  @ApiProperty()
  @IsEnum(LogLevel)
  level!: LogLevel;

  @ApiProperty()
  @IsString()
  message!: string;

  @ApiPropertyOptional()
  @ValidateIf((_, v) => v !== undefined) // Optional, but null is invalid
  @IsString()
  stackTrace?: string;

  @ApiPropertyOptional()
  @ValidateIf((_, v) => v !== undefined) // Optional, but null is invalid
  @IsString()
  context?: string;
}
