import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  Logger,
} from '@nestjs/common';
import { HttpAdapterHost } from '@nestjs/core';
import { Request, Response } from 'express';
import { ApiResponse } from 'src/common/types/api-response.type';
import { ApiErrorCode } from './api-error-code.enum';

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

    const responseBody: ApiResponse<null> = {
      error: { code: ApiErrorCode.SERVER_ERROR },
      data: null,
    };

    this.logger.error(
      `[${request.method}] ${httpAdapter.getRequestUrl(request)} - Status code: ${statusCode} - Message: ${message}`,
    );
    httpAdapter.reply(response, responseBody, statusCode);
  }
}
