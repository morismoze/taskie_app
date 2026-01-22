import { Injectable } from '@nestjs/common';
import { ClsService } from 'nestjs-cls';
import { PinoLogger } from 'nestjs-pino';
import {
  CLS_CONTEXT_APP_METADATA_KEY,
  CLS_CONTEXT_USER_ID_KEY,
} from 'src/common/helper/constants';
import { UserClsContext } from 'src/common/interceptors/user-context.interceptor';
import { AppMetadataClsContext } from 'src/common/middlewares/app-metadata-context.middleware';
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
    const userId = this.cls.get<UserClsContext>(CLS_CONTEXT_USER_ID_KEY);
    const appMetadata = this.cls.get<AppMetadataClsContext>(
      CLS_CONTEXT_APP_METADATA_KEY,
    );

    // Connect the data
    const logObject = {
      ...(typeof message === 'object' ? message : { msg: message }),
      trace,
      userId,
      appMetadata,
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
    const userId = this.cls.get<UserClsContext>(CLS_CONTEXT_USER_ID_KEY);
    const appMetadata = this.cls.get<AppMetadataClsContext>(
      CLS_CONTEXT_APP_METADATA_KEY,
    );

    const logObject = { userId, appMetadata, context };

    if (typeof message === 'string') {
      this.logger[level](logObject, message);
    } else {
      this.logger[level]({ ...message, ...logObject });
    }
  }
}
