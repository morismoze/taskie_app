import { registerAs } from '@nestjs/config';
import { AppConfig } from './app-config.model';
import validateConfig from '../common/helper/validate-config';
import { IsEnum, IsInt, IsOptional, IsString, Max, Min } from 'class-validator';

enum Environment {
  Development = 'development',
  Staging = 'staging',
  Production = 'production',
}

class EnvironmentVariablesValidator {
  @IsEnum(Environment)
  @IsOptional()
  NODE_ENV?: Environment;

  @IsOptional()
  @IsString()
  APP_NAME?: string;

  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(65535)
  APP_PORT?: number;

  @IsOptional()
  @IsString()
  API_PREFIX?: string;
}

export default registerAs<AppConfig>('app', () => {
  validateConfig(process.env, EnvironmentVariablesValidator);

  return {
    nodeEnv: process.env.NODE_ENV || 'development',
    name: process.env.APP_NAME || 'app',
    port: process.env.APP_PORT ? parseInt(process.env.APP_PORT, 10) : 5000,
    apiPrefix: process.env.API_PREFIX || 'api',
  };
});
