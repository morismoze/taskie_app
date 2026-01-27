import {
  ClassSerializerInterceptor,
  MiddlewareConsumer,
  Module,
  NestModule,
  ValidationPipe,
} from '@nestjs/common';

import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR, APP_PIPE } from '@nestjs/core';
import { ScheduleModule } from '@nestjs/schedule';
import { ClsMiddleware, ClsModule } from 'nestjs-cls';
import getValidationOptions from './common/helper/validation-options';
import { ResponseTransformerInterceptor } from './common/interceptors/response-transformer.intereptor';
import { UserContextInterceptor } from './common/interceptors/user-context.interceptor';
import { AppMetadataContextMiddleware } from './common/middlewares/app-metadata-context.middleware';
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
import { HealthModule } from './modules/health/health.module';
import { LoggerMobileModule } from './modules/logger-mobile/logger-mobile.module';
import { AppLogger } from './modules/logger/app-logger';
import grafanaConfig from './modules/logger/config/grafana.config';
import { AppLoggerModule } from './modules/logger/logger.module';
import { UserModule } from './modules/user/user.module';
import { WorkspaceModule } from './modules/workspace/workspace-module/workspace.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [
        appConfig,
        databaseConfig,
        authConfig,
        googleConfig,
        grafanaConfig,
      ],
      envFilePath: [
        // `.env.${process.env.NODE_ENV}`, // First try to search the process ENV
        '.env', // Fallback to default .env
      ],
    }),
    // CLS needs to initalize before any other middleware tries to do actions on the request object
    ClsModule.forRoot({
      global: true,
      // We initialize the CLS middleware below where we define other middlewares.
      // In our case it's only the AppMetadataContextMiddleware and it requires
      // CLS middleware, so we need to explicitly define the order of initalizing
      // middlewares (first the CLS middleware, then the AppMetadataContextMiddleware).
      middleware: { mount: false },
    }),
    AppLoggerModule,
    DatabaseModule,
    AuthModule,
    AuthGoogleModule,
    UserModule,
    WorkspaceModule,
    HealthModule,
    LoggerMobileModule,
    ScheduleModule.forRoot(),
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
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(ClsMiddleware, AppMetadataContextMiddleware).forRoutes('*');
  }
}
