import { Module } from '@nestjs/common';

import { DatabaseModule } from './modules/database/database.module';
import { AppConfigModule } from './modules/app-config/app-config.module';
import { UserModule } from './modules/user/user.module';
import { AuthModule } from './modules/auth/core/auth.module';
import { WorkspaceModule } from './modules/workspace/workspace-module/workspace.module';
import { AuthGoogleModule } from './modules/auth/auth-google/auth-google.module';

@Module({
  imports: [
    AppConfigModule,
    DatabaseModule,
    AuthModule,
    AuthGoogleModule,
    UserModule,
    WorkspaceModule,
  ],
})
export class AppModule {}
