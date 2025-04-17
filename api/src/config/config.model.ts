import { AuthConfig } from 'src/modules/auth/core/config/auth-config.model';
import { DatabaseConfig } from 'src/database/config/database-config.model';
import { AppConfig } from './app-config.model';
import { GoogleConfig } from './google/google-config.model';

export interface AggregatedConfig {
  app: AppConfig;
  database: DatabaseConfig;
  auth: AuthConfig;
  google: GoogleConfig;
}
