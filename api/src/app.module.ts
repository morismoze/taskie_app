import { Module } from '@nestjs/common';

import { UserModule } from './modules/user/user.module';
import { AuthModule } from './modules/auth/core/auth.module';
import { WorkspaceModule } from './modules/workspace/workspace-module/workspace.module';
import { AuthGoogleModule } from './modules/auth/auth-google/auth-google.module';
import { ConfigModule } from '@nestjs/config';
import appConfig from './config/app.config';
import databaseConfig from './database/config/database.config';
import authConfig from './modules/auth/core/config/auth.config';
import googleConfig from './modules/auth/auth-google/config/google.config';
import { DatabaseModule } from './modules/database/database.module';
import { ScheduleModule } from '@nestjs/schedule';

@Module({
  imports: [
    ConfigModule.forRoot({
      // enables this AppConfigModule module to be usable everywhere inside app context without
      // the need to import it (using imports: [AppModule]) - it's auto injected
      isGlobal: true,
      // these are custom config factories — functions that take process.env and return structured config
      load: [appConfig, databaseConfig, authConfig, googleConfig],
      // loads and parses the .env file.
      // makes process.env.VARIABLE values available at runtime.
      envFilePath: ['.env'],
    }),
    DatabaseModule,
    AuthModule,
    AuthGoogleModule,
    UserModule,
    WorkspaceModule,
    ScheduleModule.forRoot(),
  ],
})
export class AppModule {}
