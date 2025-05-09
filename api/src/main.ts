import 'dotenv/config';
import { HttpAdapterHost, NestFactory, Reflector } from '@nestjs/core';
import { ConfigService } from '@nestjs/config';
import { AppModule } from './app.module';
import { AggregatedConfig } from './config/config.type';
import { ClassSerializerInterceptor, ValidationPipe } from '@nestjs/common';
import getValidationOptions from './common/helper/validation-options';
import { RootExceptionsFilter } from './exception/root-exceptions.filter';
import { ResponseTransformerInterceptor } from './common/interceptors/response-transformer.intereptor';
import { RequestMetadataProcessingInterceptor } from './common/interceptors/request-metadata-processing.interceptor';
import { NestExpressApplication } from '@nestjs/platform-express';
import { Environment } from './config/app.config';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  const configService = app.get(ConfigService<AggregatedConfig>);
  const isDevelopment =
    configService.getOrThrow('app.nodeEnv', { infer: true }) ===
    Environment.DEVELOPMENT;

  app.setGlobalPrefix(
    configService.getOrThrow('app.apiPrefix', { infer: true }),
    {
      exclude: ['/'],
    },
  );
  const validationOptions = getValidationOptions(configService);
  app.useGlobalPipes(new ValidationPipe(validationOptions));
  app.useGlobalFilters(new RootExceptionsFilter(app.get(HttpAdapterHost)));
  app.useGlobalInterceptors(new ClassSerializerInterceptor(app.get(Reflector)));
  app.useGlobalInterceptors(new RequestMetadataProcessingInterceptor());
  app.useGlobalInterceptors(new ResponseTransformerInterceptor());

  if (!isDevelopment) {
    // This tells Express/Nest to respect the X-Forwarded-For header — otherwise request.ip will return the proxy’s IP
    app.set('trust proxy', true);
  }

  app.enableShutdownHooks();

  await app.listen(configService.getOrThrow('app.port', { infer: true }));
}

bootstrap();
