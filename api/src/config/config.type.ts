import { AuthConfig } from 'src/modules/auth/core/config/auth-config.type';
import { DatabaseConfig } from 'src/database/config/database-config.type';
import { AppConfig } from './app-config.type';
import { GoogleConfig } from '../modules/auth/auth-google/config/google-config.type';

export interface AggregatedConfig {
  app: AppConfig;
  database: DatabaseConfig;
  auth: AuthConfig;
  google: GoogleConfig;
}
