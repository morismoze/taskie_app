import { registerAs } from '@nestjs/config';
import { AppConfig } from './app-config.model';
import validateConfig from '../common/helper/validate-config';
import { IsEnum, IsInt, IsOptional, IsString, Max, Min } from 'class-validator';

export enum Environment {
  DEVELOPMENT = 'development',
  STAGING = 'staging',
  PRODUCTION = 'production',
}

class EnvironmentVariablesValidator {
  @IsEnum(Environment)
  @IsOptional()
  NODE_ENV: Environment;

  @IsOptional()
  @IsString()
  APP_NAME: string;

  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(65535)
  APP_PORT: number;

  @IsOptional()
  @IsString()
  API_PREFIX: string;
}

export default registerAs<AppConfig>('app', (): AppConfig => {
  validateConfig(process.env, EnvironmentVariablesValidator);

  return {
    nodeEnv: process.env.NODE_ENV || 'development',
    name: process.env.APP_NAME || 'TaskieAPI',
    port: process.env.APP_PORT ? parseInt(process.env.APP_PORT, 10) : 5000,
    apiPrefix: process.env.API_PREFIX || '/api',
  };
});
