import { AuthConfig } from 'src/modules/auth/config/auth-config.model';
import { DatabaseConfig } from 'src/database/config/database-config.model';
import { AppConfig } from './app-config.model';

export interface AggregatedConfig {
  app: AppConfig;
  database: DatabaseConfig;
  auth: AuthConfig;
}
