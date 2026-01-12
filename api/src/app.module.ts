import {
  ClassSerializerInterceptor,
  Module,
  ValidationPipe,
} from '@nestjs/common';

import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR, APP_PIPE } from '@nestjs/core';
import { ScheduleModule } from '@nestjs/schedule';
import { ServeStaticModule } from '@nestjs/serve-static';
import { ClsModule } from 'nestjs-cls';
import { join } from 'path';
import getValidationOptions from './common/helper/validation-options';
import { RequestMetadataProcessingInterceptor } from './common/interceptors/request-metadata-processing.interceptor';
import { ResponseTransformerInterceptor } from './common/interceptors/response-transformer.intereptor';
import { UserContextInterceptor } from './common/interceptors/user-context.interceptor';
import appConfig from './config/app.config';
import { AggregatedConfig } from './config/config.type';
import databaseConfig from './database/config/database.config';
import { ApiHttpExceptionsFilter } from './exception/api-http-exceptions.filter';
import { BaseHttpExceptionsFilter } from './exception/base-http-exceptions.filter';
import { UnknownExceptionsFilter } from './exception/unknown-exceptions.filter';
import { AuthGoogleModule } from './modules/auth/auth-google/auth-google.module';
import googleConfig from './modules/auth/auth-google/config/google.config';
import { AuthModule } from './modules/auth/core/auth.module';
import authConfig from './modules/auth/core/config/auth.config';
import { DatabaseModule } from './modules/database/database.module';
import { AppLogger } from './modules/logger/app-logger';
import { AppLoggerModule } from './modules/logger/logger.module';
import { UserModule } from './modules/user/user.module';
import { WorkspaceModule } from './modules/workspace/workspace-module/workspace.module';

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
    ClsModule.forRoot({
      global: true,
      middleware: { mount: true }, // Automatically mounts middleware for every request
    }),
    AppLoggerModule,
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'client'),
    }),
  ],
  providers: [
    {
      provide: APP_FILTER,
      useClass: UnknownExceptionsFilter,
    },
    {
      provide: APP_FILTER,
      useClass: BaseHttpExceptionsFilter,
    },
    {
      provide: APP_FILTER,
      useClass: ApiHttpExceptionsFilter,
    },
    {
      provide: APP_INTERCEPTOR,
      useClass: UserContextInterceptor,
    },
    {
      provide: APP_INTERCEPTOR,
      useClass: RequestMetadataProcessingInterceptor,
    },
    {
      provide: APP_INTERCEPTOR,
      useClass: ClassSerializerInterceptor,
    },
    {
      provide: APP_INTERCEPTOR,
      useClass: ResponseTransformerInterceptor,
    },
    {
      provide: APP_PIPE,
      // Since validations options is not a class, but
      // rather a function, we must use useFactory
      useFactory: (
        configService: ConfigService<AggregatedConfig>,
        logger: AppLogger,
      ) => {
        const options = getValidationOptions(configService, logger);
        return new ValidationPipe(options);
      },
      inject: [ConfigService, AppLogger], // Here we define what we need in the factory
    },
  ],
})
export class AppModule {}
