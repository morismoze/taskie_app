import { Module } from '@nestjs/common';
import { AuthModule } from './modules/auth/auth.module';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TypeOrmConfigLoadService } from './database/typeorm-config.service';
import { DataSource, DataSourceOptions } from 'typeorm';
import appConfig from './config/app.config';
import databaseConfig from './database/config/database.config';
import authConfig from './modules/auth/config/auth.config';
import { UserModule } from './modules/user/user.module';

@Module({
  imports: [
    // this loads and structures .env values into accessible config object
    // so it can be used thorughout the code as e.g. configService.getOrThrow('app.port')
    // basically agregates everything from appConfig, databaseConfig, authConfig and .env file into one configService object
    ConfigModule.forRoot({
      // enables this AppModule module to be usable everywhere inside app context without
      // the need to import it (using imports: [AppModule]) - it's auto injected
      isGlobal: true,
      // these are custom config factories — functions that take process.env and return structured config
      load: [appConfig, databaseConfig, authConfig],
      // loads and parses the .env file.
      // makes process.env.VARIABLE values available at runtime.
      envFilePath: ['.env'],
    }),
    // bootstraps a TypeORM database connection dynamically, using config that's loaded via ConfigService
    TypeOrmModule.forRootAsync({
      // uses TypeOrmConfigLoadService service to load DB config
      useClass: TypeOrmConfigLoadService,
      // initializes and returns a TypeORM DataSource
      dataSourceFactory: async (options: DataSourceOptions) => {
        return new DataSource(options).initialize();
      },
    }),
    AuthModule,
    UserModule,
  ],
})
export class AppModule {}
