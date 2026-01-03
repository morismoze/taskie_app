import { Global, Module } from '@nestjs/common';
import { AppLogger } from './app-logger';
import { ConsoleAppLogger } from './console-app-logger.adapter';

@Global()
@Module({
  // In the future, when there will be the need to change
  // Nest's logger to a real 3rd party logger (Pino, Datadog,
  // Winston, ...), only the new adapter class needs to be made.
  providers: [{ provide: AppLogger, useClass: ConsoleAppLogger }],
  exports: [AppLogger],
})
export class AppLoggerModule {}
