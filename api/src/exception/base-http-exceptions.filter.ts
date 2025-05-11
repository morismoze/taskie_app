import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  Logger,
} from '@nestjs/common';
import { HttpAdapterHost } from '@nestjs/core';
import { Request, Response } from 'express';

@Catch(HttpException)
export class BaseHttpExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger(BaseHttpExceptionsFilter.name);

  constructor(private readonly httpAdapterHost: HttpAdapterHost) {}

  catch(exception: HttpException, host: ArgumentsHost): void {
    const { httpAdapter } = this.httpAdapterHost;
    const ctx = host.switchToHttp();
    const request = ctx.getRequest<Request>();
    const response = ctx.getResponse<Response>();
    const statusCode = exception.getStatus();
    const { message } = exception.getResponse() as unknown as {
      message: string;
    };

    this.logger.error(
      `[${request.method}] ${httpAdapter.getRequestUrl(request)} - Status code: ${statusCode} - Message: ${message}`,
    );
    httpAdapter.reply(response, undefined, statusCode);
  }
}
