import 'reflect-metadata';
import { DataSource, DataSourceOptions } from 'typeorm';

// TypeORM config used outside of NestJS context, e.g. in migration CLI scripts

export const AppDataSource = new DataSource({
  type: process.env.DATABASE_TYPE,
  host: process.env.DATABASE_HOST,
  port: Number(process.env.DATABASE_PORT),
  database: process.env.DATABASE_NAME,
  username: process.env.DATABASE_USERNAME,
  password: process.env.DATABASE_PASSWORD,
  dropSchema: false,
  entities: [__dirname + '/../modules/**/*.entity{.ts,.js}'],
  migrations: [__dirname + '/migrations/**/*{.ts,.js}'],
  poolSize: Number(process.env.DATABASE_POOL_SIZE),
} as DataSourceOptions);
