import { registerAs } from '@nestjs/config';
import { IsString } from 'class-validator';
import validateConfig from 'src/common/helper/validate-config';
import { GoogleConfig } from './google-config.type';

export enum Environment {
  DEVELOPMENT = 'development',
  STAGING = 'staging',
  PRODUCTION = 'production',
}

class EnvironmentVariablesValidator {
  @IsString()
  AUTH_GOOGLE_CLIENT_ID: string;

  @IsString()
  AUTH_GOOGLE_CLIENT_SECRET: string;

  constructor(
    AUTH_GOOGLE_CLIENT_ID: string,
    AUTH_GOOGLE_CLIENT_SECRET: string,
  ) {
    this.AUTH_GOOGLE_CLIENT_ID = AUTH_GOOGLE_CLIENT_ID;
    this.AUTH_GOOGLE_CLIENT_SECRET = AUTH_GOOGLE_CLIENT_SECRET;
  }
}

export default registerAs<GoogleConfig>('app', (): GoogleConfig => {
  validateConfig(process.env, EnvironmentVariablesValidator);

  // env vars will be defined after validateConfig is invoked
  // and it asserted the needed env vars are set
  const env = process.env as unknown as EnvironmentVariablesValidator;

  return {
    auth: {
      clientId: env.AUTH_GOOGLE_CLIENT_ID,
      clientSecret: env.AUTH_GOOGLE_CLIENT_SECRET,
    },
  };
});
