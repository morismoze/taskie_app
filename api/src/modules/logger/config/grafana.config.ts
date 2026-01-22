import { registerAs } from '@nestjs/config';
import { IsNotEmpty, IsString, ValidateIf } from 'class-validator';
import validateConfig from 'src/common/helper/validate-config';
import { Environment } from 'src/config/app.config';
import { GrafanaConfig } from './grafana-config.type';

class GrafanaEnvironmentVariablesValidator {
  @ValidateIf(() => process.env.NODE_ENV === Environment.PRODUCTION)
  @IsNotEmpty()
  @IsString()
  GRAFANA_LOGS_LOKI_HOST: string;

  @ValidateIf(() => process.env.NODE_ENV === Environment.PRODUCTION)
  @IsNotEmpty()
  @IsString()
  GRAFANA_LOGS_LOKI_USER: string;

  @ValidateIf(() => process.env.NODE_ENV === Environment.PRODUCTION)
  @IsNotEmpty()
  @IsString()
  GRAFANA_LOGS_LOKI_API_KEY: string;

  constructor(
    GRAFANA_LOGS_LOKI_HOST: string,
    GRAFANA_LOGS_LOKI_USER: string,
    GRAFANA_LOGS_LOKI_API_KEY: string,
  ) {
    this.GRAFANA_LOGS_LOKI_HOST = GRAFANA_LOGS_LOKI_HOST;
    this.GRAFANA_LOGS_LOKI_USER = GRAFANA_LOGS_LOKI_USER;
    this.GRAFANA_LOGS_LOKI_API_KEY = GRAFANA_LOGS_LOKI_API_KEY;
  }
}

export default registerAs<GrafanaConfig>('grafana', (): GrafanaConfig => {
  validateConfig(process.env, GrafanaEnvironmentVariablesValidator);

  // env vars will be defined after validateConfig is invoked
  // and it asserted the needed env vars are set
  const env = process.env as unknown as GrafanaEnvironmentVariablesValidator;

  return {
    logs: {
      loki: {
        host: env.GRAFANA_LOGS_LOKI_HOST,
        user: env.GRAFANA_LOGS_LOKI_USER,
        apiKey: env.GRAFANA_LOGS_LOKI_API_KEY,
      },
    },
  };
});
