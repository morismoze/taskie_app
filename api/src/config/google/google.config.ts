import { registerAs } from '@nestjs/config';
import { IsString } from 'class-validator';
import validateConfig from 'src/common/helper/validate-config';
import { GoogleConfig } from './google-config.model';

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
}

export default registerAs<GoogleConfig>('app', (): GoogleConfig => {
  validateConfig(process.env, EnvironmentVariablesValidator);

  return {
    auth: {
      clientId: process.env.AUTH_GOOGLE_CLIENT_ID,
      clientSecret: process.env.AUTH_GOOGLE_CLIENT_SECRET,
    },
  };
});
