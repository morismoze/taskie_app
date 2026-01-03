import { Environment } from './app.config';

export type AppConfig = {
  nodeEnv: Environment;
  name: string;
  port: number;
  serverCnameUrl: string;
  apiPrefix: string;
};
