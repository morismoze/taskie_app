import { VersioningType } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import 'dotenv/config';
import { AppModule } from './app.module';
import setupApiDocs from './common/helper/api-docs';
import { Environment } from './config/app.config';
import { AggregatedConfig } from './config/config.type';
import { AppLogger } from './modules/logger/app-logger';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    bufferLogs: true, // Flushes logs to our custom logger
  });

  const logger = app.get(AppLogger);
  app.useLogger(logger); // Nest framework logs go through our custom logger
  app.flushLogs();

  const configService = app.get(ConfigService<AggregatedConfig>);
  const isDevelopment =
    configService.getOrThrow('app.nodeEnv', { infer: true }) ===
    Environment.DEVELOPMENT;

  const apiPrefix = configService.getOrThrow('app.apiPrefix', { infer: true });
  app.setGlobalPrefix(apiPrefix, {
    exclude: ['/'],
  });
  app.enableVersioning({
    type: VersioningType.URI,
  });

  setupApiDocs(app, apiPrefix);

  if (!isDevelopment) {
    // This tells Express/Nest to respect the X-Forwarded-For header — otherwise request.ip will return the proxy’s IP
    app.set('trust proxy', true);
  }

  app.enableShutdownHooks();

  await app.listen(configService.getOrThrow('app.port', { infer: true }));
  logger.log(
    `This application is runnning on: ${await app.getUrl()}`,
    'Bootstrap',
  );
}

bootstrap();
