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

/**
 * For example: 404 Not Found, 413 Payload Too Large, etc..
 */

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
    const exceptionResponse = exception.getResponse();
    const { message } = exceptionResponse as unknown as {
      message: string;
    };

    const logPayload = {
      msg: `Framework Exception: ${statusCode}`,
      statusCode,
      req: {
        method: request.method,
        url: request.originalUrl || request.url,
        ip: request.ip,
        userAgent: request.headers['user-agent'],
      },
      frameworkMessage: message,
    };

    // Separation logic
    if (statusCode >= 500) {
      // Real framework server error
      this.logger.error(
        { ...logPayload, err: exception },
        exception.stack,
        BaseHttpExceptionsFilter.name,
      );
    } else {
      // 404, 403, 401... (Client errors) -> WARN
      // No need for stacktrace
      this.logger.warn(logPayload, BaseHttpExceptionsFilter.name);
    }

    const responseBody: ApiResponse<null> = {
      error: { code: ApiErrorCode.SERVER_ERROR },
      data: null,
    };

    httpAdapter.reply(response, responseBody, statusCode);
  }
}
