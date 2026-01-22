import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import 'dotenv/config';
import { AppModule } from './app.module';
import setupApiDocs from './common/helper/setup-api-docs';
import { setupApiMeta } from './common/helper/setup-api-meta';
import { setupHttpSecurity } from './common/helper/setup-http-security';
import { setupLogger } from './common/helper/setup-logger';
import { AggregatedConfig } from './config/config.type';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    bufferLogs: true, // Buffer logs until AppLogger is instantiated and set up
  });
  const configService = app.get(ConfigService<AggregatedConfig>);

  const logger = setupLogger(app);

  setupHttpSecurity(app, configService);

  setupApiMeta(app, configService);

  setupApiDocs(app, configService);

  app.enableShutdownHooks();

  await app.listen(configService.getOrThrow('app.port', { infer: true }));
  logger.log(
    `This application is runnning on: ${await app.getUrl()} [env: ${process.env.NODE_ENV}]`,
    'Bootstrap',
  );
}

bootstrap();
