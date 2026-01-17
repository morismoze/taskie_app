import { ConfigService } from '@nestjs/config';
import { NestExpressApplication } from '@nestjs/platform-express';
import helmet from 'helmet';
import { Environment } from 'src/config/app.config';
import { AggregatedConfig } from 'src/config/config.type';

export const setupRequestSecurity = (
  app: NestExpressApplication,
  configService: ConfigService<AggregatedConfig>,
) => {
  app.use(helmet());

  // No need to use other body parsers (text, urlencoded, raw) as we are only expecting JSON
  // and if someone tries to send a different content-type, Nest will return a 415 Unsupported Media Type response
  app.useBodyParser('json', { limit: '10mb' });

  const isDevelopment =
    configService.getOrThrow('app.nodeEnv', { infer: true }) ===
    Environment.DEVELOPMENT;
  if (!isDevelopment) {
    // This tells Express/Nest to respect the X-Forwarded-For header — otherwise request.ip will return the proxy’s IP
    app.set('trust proxy', true);
  }
};
