import 'dotenv/config';
import { HttpAdapterHost, NestFactory, Reflector } from '@nestjs/core';
import { ConfigService } from '@nestjs/config';
import { AppModule } from './app.module';
import { AggregatedConfig } from './config/config.model';
import { ClassSerializerInterceptor, ValidationPipe } from '@nestjs/common';
import getValidationOptions from './common/helper/validation-options';
import { RootExceptionsFilter } from './exception/root-exceptions.filter';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { cors: true });
  const configService = app.get(ConfigService<AggregatedConfig>);

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

  await app.listen(configService.getOrThrow('app.port', { infer: true }));
}

bootstrap();
