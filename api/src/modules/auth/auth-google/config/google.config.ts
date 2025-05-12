import { registerAs } from '@nestjs/config';
import { IsNotEmpty, IsString } from 'class-validator';
import validateConfig from 'src/common/helper/validate-config';
import { GoogleConfig } from './google-config.type';

class GoogleEnvironmentVariablesValidator {
  @IsNotEmpty()
  @IsString()
  AUTH_GOOGLE_CLIENT_ID: string;

  @IsNotEmpty()
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

export default registerAs<GoogleConfig>('google', (): GoogleConfig => {
  validateConfig(process.env, GoogleEnvironmentVariablesValidator);

  // env vars will be defined after validateConfig is invoked
  // and it asserted the needed env vars are set
  const env = process.env as unknown as GoogleEnvironmentVariablesValidator;

  return {
    auth: {
      clientId: env.AUTH_GOOGLE_CLIENT_ID,
      clientSecret: env.AUTH_GOOGLE_CLIENT_SECRET,
    },
  };
});
