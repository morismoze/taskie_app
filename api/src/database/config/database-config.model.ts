export type DatabaseConfig = {
  type: string;
  host: string;
  port: number;
  name: string;
  username: string;
  password: string;
  maxConnections: number;
};
