import { ConsoleLogger, Injectable } from '@nestjs/common';
import { ClsService } from 'nestjs-cls';
import { AppLogger } from './app-logger';

@Injectable()
export class ConsoleAppLogger implements AppLogger {
  private readonly logger = new ConsoleLogger('App');

  constructor(private readonly cls: ClsService) {}

  log(message: any, context?: string) {
    this.logger.log(this.formatMessage(message), context);
  }

  warn(message: any, context?: string) {
    this.logger.warn(this.formatMessage(message), context);
  }

  error(message: any, stackTrace?: string, context?: string) {
    this.logger.error(this.formatMessage(message), stackTrace, context);
  }

  private formatMessage(message: any): string {
    const userId = this.cls.get('userId');
    const prefix = userId ? `[USER_ID: ${userId}] ` : '';

    // If message is an object, stringify it, or return plain message
    const msgString =
      typeof message === 'object' ? JSON.stringify(message) : message;

    return `${prefix}${msgString}`;
  }
}
