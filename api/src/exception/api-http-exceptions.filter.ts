import { ArgumentsHost, Catch, ExceptionFilter } from '@nestjs/common';
import { HttpAdapterHost } from '@nestjs/core';
import { Request, Response } from 'express';
import { ApiError, ApiResponse } from 'src/common/types/api-response.type';
import { AppLogger } from 'src/modules/logger/app-logger';
import { ApiHttpException } from './api-http-exception.type';

@Catch(ApiHttpException)
export class ApiHttpExceptionsFilter implements ExceptionFilter {
  constructor(
    private readonly httpAdapterHost: HttpAdapterHost,
    private readonly logger: AppLogger,
  ) {}

  catch(exception: ApiHttpException, host: ArgumentsHost): void {
    const { httpAdapter } = this.httpAdapterHost;
    const ctx = host.switchToHttp();
    const request = ctx.getRequest<Request>();
    const response = ctx.getResponse<Response>();
    const statusCode = exception.getStatus();
    const message = exception.getResponse() as unknown as ApiError;

    const responseBody: ApiResponse<null> = {
      error: message,
      data: null,
    };

    this.logger.error(
      `[${request.method}] ${httpAdapter.getRequestUrl(request)} - Status code: ${statusCode} - API Error code: ${JSON.stringify(message.code)}`,
      exception.stack,
    );
    httpAdapter.reply(response, responseBody, statusCode);
  }
}
