import { Injectable } from '@nestjs/common';
import { ClsService } from 'nestjs-cls';
import { PinoLogger } from 'nestjs-pino';
import { AppLogger } from './app-logger';

@Injectable()
export class PinoAppLogger implements AppLogger {
  constructor(
    private readonly logger: PinoLogger,
    private readonly cls: ClsService,
  ) {
    this.logger.setContext('App');
  }

  log(message: any, context?: string) {
    this.callPino('info', message, context);
  }

  warn(message: any, context?: string) {
    this.callPino('warn', message, context);
  }

  error(message: any, stackTrace?: string, context?: string) {
    // Pino error mhas the following signature: (obj, msg, ...args)
    // If message is an object, Pino will serialize it correctly

    const trace =
      stackTrace || (message instanceof Error ? message.stack : undefined);
    const userId = this.cls.get('userId');

    // Connect the data
    const logObject = {
      ...(typeof message === 'object' ? message : { msg: message }),
      trace,
      userId,
      context,
    };

    this.logger.error(
      logObject,
      typeof message === 'string' ? message : 'Error occurred',
    );
  }

  private callPino(
    level: 'info' | 'warn' | 'error' | 'debug',
    message: any,
    context?: string,
  ) {
    const userId = this.cls.get('userId');

    if (typeof message === 'string') {
      this.logger[level]({ userId, context }, message);
    } else {
      this.logger[level]({ ...message, userId, context });
    }
  }
}
