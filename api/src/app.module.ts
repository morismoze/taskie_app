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
      isGlobal: true,
      load: [appConfig, databaseConfig, authConfig, googleConfig],
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
