import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
} from '@nestjs/common';
import { HttpAdapterHost } from '@nestjs/core';
import { Request, Response } from 'express';
import { ApiResponse } from 'src/common/types/api-response.type';
import { AppLogger } from 'src/modules/logger/app-logger';
import { ApiErrorCode } from './api-error-code.enum';

@Catch(HttpException)
export class BaseHttpExceptionsFilter implements ExceptionFilter {
  constructor(
    private readonly httpAdapterHost: HttpAdapterHost,
    private readonly logger: AppLogger,
  ) {}

  catch(exception: HttpException, host: ArgumentsHost): void {
    const { httpAdapter } = this.httpAdapterHost;
    const ctx = host.switchToHttp();
    const request = ctx.getRequest<Request>();
    const response = ctx.getResponse<Response>();
    const statusCode = exception.getStatus();
    const { message } = exception.getResponse() as unknown as {
      message: string;
    };

    const responseBody: ApiResponse<null> = {
      error: { code: ApiErrorCode.SERVER_ERROR },
      data: null,
    };

    this.logger.error(
      `[${request.method}] ${httpAdapter.getRequestUrl(request)} - Status code: ${statusCode} - Message: ${message}`,
      exception.stack,
    );
    httpAdapter.reply(response, responseBody, statusCode);
  }
}
