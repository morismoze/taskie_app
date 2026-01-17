import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import 'dotenv/config';
import { AppModule } from './app.module';
import setupApiDocs from './common/helper/setup-api-docs';
import { setupApiMeta } from './common/helper/setup-api-meta';
import { setupLogger } from './common/helper/setup-logger';
import { setupRequestSecurity } from './common/helper/setup-request-security';
import { AggregatedConfig } from './config/config.type';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    bufferLogs: true, // Buffer logs until a logger is set up
  });
  const configService = app.get(ConfigService<AggregatedConfig>);

  const logger = setupLogger(app);

  setupRequestSecurity(app, configService);

  setupApiMeta(app, configService);

  setupApiDocs(app, configService);

  app.enableShutdownHooks();

  await app.listen(configService.getOrThrow('app.port', { infer: true }));
  logger.log(
    `This application is runnning on: ${await app.getUrl()}`,
    'Bootstrap',
  );
}

bootstrap();
