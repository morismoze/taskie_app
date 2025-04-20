import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import appConfig from 'src/modules/app-config/config/app.config';
import databaseConfig from 'src/database/config/database.config';
import authConfig from '../auth/core/config/auth.config';

@Module({
  imports: [
    // this loads and structures .env values into accessible config object
    // so it can be used thorughout the code as e.g. configService.getOrThrow('app.port')
    // basically agregates everything from appConfig, databaseConfig, authConfig and .env file into one configService object
    ConfigModule.forRoot({
      // enables this AppConfigModule module to be usable everywhere inside app context without
      // the need to import it (using imports: [AppModule]) - it's auto injected
      isGlobal: true,
      // these are custom config factories — functions that take process.env and return structured config
      load: [appConfig, databaseConfig, authConfig],
      // loads and parses the .env file.
      // makes process.env.VARIABLE values available at runtime.
      envFilePath: ['.env'],
    }),
  ],
})
export class AppConfigModule {}
