import { ConsoleLogger, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ClsService } from 'nestjs-cls';
import { Environment } from 'src/config/app.config';
import { AggregatedConfig } from 'src/config/config.type';
import { AppLogger } from './app-logger';

@Injectable()
export class ConsoleAppLogger implements AppLogger {
  private readonly logger = new ConsoleLogger('App');
  private readonly off: boolean;

  constructor(
    private readonly cls: ClsService,
    private readonly configService: ConfigService<AggregatedConfig>,
  ) {
    const env = this.configService.getOrThrow('app.nodeEnv', { infer: true });
    this.off = [Environment.PRODUCTION, Environment.STAGING].includes(env);
  }

  log(message: any, context?: string) {
    this.logger.log(this.formatMessage(message), context);
  }

  warn(message: any, context?: string) {
    if (this.off) {
      return;
    }
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
