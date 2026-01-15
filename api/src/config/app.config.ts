import { registerAs } from '@nestjs/config';
import { IsEnum, IsInt, IsNotEmpty, IsString, Max, Min } from 'class-validator';
import validateConfig from '../common/helper/validate-config';
import { AppConfig } from './app-config.type';

export enum Environment {
  DEVELOPMENT = 'development',
  PRODUCTION = 'production',
}

class AppEnvironmentVariablesValidator {
  @IsNotEmpty()
  @IsEnum(Environment)
  NODE_ENV: Environment;

  @IsNotEmpty()
  @IsString()
  APP_NAME: string;

  @IsNotEmpty()
  @IsInt()
  @Min(0)
  @Max(65535)
  APP_PORT: number;

  @IsNotEmpty()
  @IsString()
  API_PREFIX: string;

  constructor(
    NODE_ENV: Environment,
    APP_NAME: string,
    APP_PORT: number,
    APP_SERVER_CNAME_URL: string,
    API_PREFIX: string,
  ) {
    this.NODE_ENV = NODE_ENV;
    this.APP_NAME = APP_NAME;
    this.APP_PORT = APP_PORT;
    this.API_PREFIX = API_PREFIX;
  }
}

export default registerAs<AppConfig>('app', (): AppConfig => {
  validateConfig(process.env, AppEnvironmentVariablesValidator);

  // env vars will be defined after validateConfig is invoked
  // and it asserted the needed env vars are set
  const env = process.env as unknown as AppEnvironmentVariablesValidator;

  return {
    nodeEnv: env.NODE_ENV,
    name: env.APP_NAME,
    port: env.APP_PORT,
    apiPrefix: env.API_PREFIX,
  };
});
