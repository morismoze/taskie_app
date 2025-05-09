import { registerAs } from '@nestjs/config';
import { AuthConfig } from 'src/modules/auth/core/config/auth-config.type';
import { IsInt, IsString } from 'class-validator';
import validateConfig from '../../../../common/helper/validate-config';

class EnvironmentVariablesValidator {
  @IsString()
  AUTH_JWT_SECRET: string;

  @IsInt()
  AUTH_JWT_TOKEN_EXPIRES_IN: number;

  @IsString()
  AUTH_REFRESH_SECRET: string;

  @IsInt()
  AUTH_REFRESH_TOKEN_EXPIRES_IN: number;

  @IsString()
  AUTH_GOOGLE_CLIENT_ID: string;

  @IsString()
  AUTH_GOOGLE_CLIENT_SECRET: string;

  constructor(
    AUTH_JWT_SECRET: string,
    AUTH_JWT_TOKEN_EXPIRES_IN: number,
    AUTH_REFRESH_SECRET: string,
    AUTH_REFRESH_TOKEN_EXPIRES_IN: number,
    AUTH_GOOGLE_CLIENT_ID: string,
    AUTH_GOOGLE_CLIENT_SECRET: string,
  ) {
    this.AUTH_JWT_SECRET = AUTH_JWT_SECRET;
    this.AUTH_JWT_TOKEN_EXPIRES_IN = AUTH_JWT_TOKEN_EXPIRES_IN;
    this.AUTH_REFRESH_SECRET = AUTH_REFRESH_SECRET;
    this.AUTH_REFRESH_TOKEN_EXPIRES_IN = AUTH_REFRESH_TOKEN_EXPIRES_IN;
    this.AUTH_GOOGLE_CLIENT_ID = AUTH_GOOGLE_CLIENT_ID;
    this.AUTH_GOOGLE_CLIENT_SECRET = AUTH_GOOGLE_CLIENT_SECRET;
  }
}

export default registerAs<AuthConfig>('auth', (): AuthConfig => {
  validateConfig(process.env, EnvironmentVariablesValidator);

  // env vars will be defined after validateConfig is invoked
  // and it asserted the needed env vars are set
  const env = process.env as unknown as EnvironmentVariablesValidator;

  return {
    secret: env.AUTH_JWT_SECRET,
    expires: env.AUTH_JWT_TOKEN_EXPIRES_IN,
    refreshSecret: env.AUTH_REFRESH_SECRET,
    refreshExpires: env.AUTH_REFRESH_TOKEN_EXPIRES_IN,
  };
});
