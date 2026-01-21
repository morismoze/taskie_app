import { ArgumentsHost, Catch, ExceptionFilter } from '@nestjs/common';
import { HttpAdapterHost } from '@nestjs/core';
import { Request, Response } from 'express';
import { ApiError, ApiResponse } from 'src/common/types/api-response.type';
import { AppLogger } from 'src/modules/logger/app-logger';
import { ApiErrorCode } from './api-error-code.enum';
import { ApiHttpException } from './api-http-exception.type';

@Catch(ApiHttpException)
export class ApiHttpExceptionsFilter implements ExceptionFilter {
  constructor(
    private readonly httpAdapterHost: HttpAdapterHost,
    private readonly logger: AppLogger,
  ) {}

  private readonly CRITICAL_ERROR_CODES = [ApiErrorCode.SERVER_ERROR];

  catch(exception: ApiHttpException, host: ArgumentsHost): void {
    const { httpAdapter } = this.httpAdapterHost;
    const ctx = host.switchToHttp();
    const request = ctx.getRequest<Request>();
    const response = ctx.getResponse<Response>();
    const statusCode = exception.getStatus();
    const errorResponse = exception.getResponse() as unknown as ApiError;

    const logPayload = {
      msg: `Business Logic Exception: ${errorResponse.code}`,
      errorCode: errorResponse.code,
      statusCode,
      req: {
        method: request.method,
        url: request.originalUrl || request.url,
        ip: request.ip,
        userAgent: request.headers['user-agent'],
      },
    };
    const isServerFault = statusCode >= 500;
    const isCriticalCode = this.CRITICAL_ERROR_CODES.includes(
      errorResponse.code as ApiErrorCode,
    );
    if (isServerFault || isCriticalCode) {
      this.logger.error(
        { ...logPayload, err: exception },
        exception.stack,
        ApiHttpExceptionsFilter.name,
      );
    } else {
      // User error/business rule error -> level: WARN (without stacktrace)
      // Examples: TASK_CLOSED, INVALID_PAYLOAD, EMAIL_ALREADY_EXISTS...
      this.logger.warn(logPayload, ApiHttpExceptionsFilter.name);
    }

    const responseBody: ApiResponse<null> = {
      error: errorResponse,
      data: null,
    };

    httpAdapter.reply(response, responseBody, statusCode);
  }
}
