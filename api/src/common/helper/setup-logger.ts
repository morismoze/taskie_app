import { NestExpressApplication } from '@nestjs/platform-express';
import { AppLogger } from 'src/modules/logger/app-logger';

export const setupLogger = (app: NestExpressApplication): AppLogger => {
  const logger = app.get(AppLogger);
  app.useLogger(logger); // Nest framework logs go through our custom logger
  app.flushLogs();

  return logger;
};
