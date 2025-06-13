import { registerAs } from '@nestjs/config';
import {
  IsInt,
  Min,
  Max,
  IsString,
  IsNumber,
  IsNotEmpty,
} from 'class-validator';
import validateConfig from '../../common/helper/validate-config';
import { DatabaseConfig } from './database-config.type';

class DatabaseEnvironmentVariablesValidator {
  @IsNotEmpty()
  @IsString()
  DATABASE_TYPE: string;

  @IsNotEmpty()
  @IsString()
  DATABASE_HOST: string;

  @IsNotEmpty()
  @IsInt()
  @Min(0)
  @Max(65535)
  DATABASE_PORT: number;

  @IsNotEmpty()
  @IsString()
  DATABASE_NAME: string;

  @IsNotEmpty()
  @IsString()
  DATABASE_USERNAME: string;

  @IsNotEmpty()
  @IsString()
  DATABASE_PASSWORD: string;

  @IsNotEmpty()
  @IsNumber()
  DATABASE_POOL_SIZE: number;

  @IsNotEmpty()
  @IsString()
  DATABASE_PGADMIN_EMAIL: string;

  @IsNotEmpty()
  @IsString()
  DATABASE_PGADMIN_PASSWORD: string;

  constructor(
    DATABASE_TYPE: string,
    DATABASE_HOST: string,
    DATABASE_PORT: number,
    DATABASE_NAME: string,
    DATABASE_USERNAME: string,
    DATABASE_PASSWORD: string,
    DATABASE_POOL_SIZE: number,
    DATABASE_PGADMIN_EMAIL: string,
    DATABASE_PGADMIN_PASSWORD: string,
  ) {
    this.DATABASE_TYPE = DATABASE_TYPE;
    this.DATABASE_HOST = DATABASE_HOST;
    this.DATABASE_PORT = DATABASE_PORT;
    this.DATABASE_NAME = DATABASE_NAME;
    this.DATABASE_USERNAME = DATABASE_USERNAME;
    this.DATABASE_PASSWORD = DATABASE_PASSWORD;
    this.DATABASE_POOL_SIZE = DATABASE_POOL_SIZE;
    this.DATABASE_PGADMIN_EMAIL = DATABASE_PGADMIN_EMAIL;
    this.DATABASE_PGADMIN_PASSWORD = DATABASE_PGADMIN_PASSWORD;
  }
}

export default registerAs<DatabaseConfig>('database', (): DatabaseConfig => {
  validateConfig(process.env, DatabaseEnvironmentVariablesValidator);

  // env vars will be defined after validateConfig is invoked
  // and it asserted the needed env vars are set
  const env = process.env as unknown as DatabaseEnvironmentVariablesValidator;

  return {
    type: env.DATABASE_TYPE,
    host: env.DATABASE_HOST,
    port: env.DATABASE_PORT,
    name: env.DATABASE_NAME,
    username: env.DATABASE_USERNAME,
    password: env.DATABASE_PASSWORD,
    poolSize: env.DATABASE_POOL_SIZE,
  };
});
