import { VersioningType } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestExpressApplication } from '@nestjs/platform-express';
import { AggregatedConfig } from 'src/config/config.type';

export const setupApiMeta = (
  app: NestExpressApplication,
  configService: ConfigService<AggregatedConfig>,
) => {
  const apiPrefix = configService.getOrThrow('app.apiPrefix', { infer: true });
  app.setGlobalPrefix(apiPrefix, {
    exclude: ['/'],
  });
  app.enableVersioning({
    type: VersioningType.URI,
  });
};
