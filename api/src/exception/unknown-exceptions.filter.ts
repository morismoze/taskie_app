import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  Logger,
  HttpStatus,
} from '@nestjs/common';
import { HttpAdapterHost } from '@nestjs/core';
import { Request, Response } from 'express';

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
    const message = 'Internal server error';

    this.logger.error(
      `[${request.method}] ${httpAdapter.getRequestUrl(request)} - ${statusCode} - ${message}`,
      exception,
    );
    httpAdapter.reply(response, undefined, statusCode);
  }
}
