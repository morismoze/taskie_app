import { registerAs } from '@nestjs/config';
import { DatabaseConfig } from './database-config.model';
import {
  IsInt,
  Min,
  Max,
  IsString,
  IsOptional,
  IsNumber,
} from 'class-validator';
import validateConfig from '../../common/helper/validate-config';

class EnvironmentVariablesValidator {
  @IsString()
  DATABASE_TYPE: string;

  @IsString()
  DATABASE_HOST: string;

  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(65535)
  DATABASE_PORT?: number;

  @IsString()
  DATABASE_NAME: string;

  @IsString()
  DATABASE_USERNAME: string;

  @IsString()
  DATABASE_PASSWORD: string;

  @IsOptional()
  @IsNumber()
  DATABASE_MAX_CONNECTIONS?: number;
}

export default registerAs<DatabaseConfig>('database', () => {
  validateConfig(process.env, EnvironmentVariablesValidator);

  return {
    type: process.env.DATABASE_TYPE!,
    host: process.env.DATABASE_HOST!,
    port: process.env.DATABASE_PORT
      ? parseInt(process.env.DATABASE_PORT, 10)
      : 5432,
    name: process.env.DATABASE_NAME!,
    username: process.env.DATABASE_USERNAME!,
    password: process.env.DATABASE_PASSWORD!,
    maxConnections: process.env.DATABASE_MAX_CONNECTIONS
      ? parseInt(process.env.DATABASE_MAX_CONNECTIONS, 10)
      : 100,
  };
});
