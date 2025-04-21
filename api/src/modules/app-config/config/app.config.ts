import { registerAs } from '@nestjs/config';
import { AppConfig } from './app-config.model';
import validateConfig from '../../../common/helper/validate-config';
import { IsEnum, IsInt, IsString, Max, Min } from 'class-validator';

export enum Environment {
  DEVELOPMENT = 'development',
  STAGING = 'staging',
  PRODUCTION = 'production',
}

class EnvironmentVariablesValidator {
  @IsEnum(Environment)
  NODE_ENV: Environment;

  @IsString()
  APP_NAME: string;

  @IsInt()
  @Min(0)
  @Max(65535)
  APP_PORT: number;

  @IsString()
  API_PREFIX: string;
}

export default registerAs<AppConfig>('app', (): AppConfig => {
  validateConfig(process.env, EnvironmentVariablesValidator);

  // env vars will be defined after validateConfig is invoked
  // and it asserted the needed env vars are set
  const env = process.env as unknown as EnvironmentVariablesValidator;

  return {
    nodeEnv: env.NODE_ENV,
    name: env.APP_NAME,
    port: env.APP_PORT,
    apiPrefix: env.API_PREFIX,
  };
});
