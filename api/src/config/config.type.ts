import { DatabaseConfig } from 'src/database/config/database-config.type';
import { AuthConfig } from 'src/modules/auth/core/config/auth-config.type';
import { GrafanaConfig } from 'src/modules/logger/config/grafana-config.type';
import { GoogleConfig } from '../modules/auth/auth-google/config/google-config.type';
import { AppConfig } from './app-config.type';

export interface AggregatedConfig {
  app: AppConfig;
  database: DatabaseConfig;
  auth: AuthConfig;
  google: GoogleConfig;
  grafana: GrafanaConfig;
}
