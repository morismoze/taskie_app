import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  Logger,
  HttpStatus,
} from '@nestjs/common';
import { HttpAdapterHost } from '@nestjs/core';
import { Request, Response } from 'express';

/**
 * Global-scoped filters are used across the whole application, for every controller and every route handler.
 * So this won't catch errors outside of those contexts (e.g. validateConfig function, or forRoot initializations).
 */

@Catch(Error)
export class UnknownExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger(UnknownExceptionsFilter.name);

  constructor(private readonly httpAdapterHost: HttpAdapterHost) {}

  catch(exception: Error, host: ArgumentsHost): void {
    const { httpAdapter } = this.httpAdapterHost;
    const ctx = host.switchToHttp();
    const request = ctx.getRequest<Request>();
    const response = ctx.getResponse<Response>();
    const statusCode = HttpStatus.INTERNAL_SERVER_ERROR;
    const message = exception.message;

    this.logger.error(
      `[${request.method}] ${httpAdapter.getRequestUrl(request)} - ${statusCode} - ${message}`,
      exception.stack,
    );
    httpAdapter.reply(response, undefined, statusCode);
  }
}
