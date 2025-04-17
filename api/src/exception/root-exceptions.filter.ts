import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { HttpAdapterHost } from '@nestjs/core';
import { ApiError, ApiResponse } from 'src/common/types/api-response.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from './ApiHttpException.model';

@Catch()
export class RootExceptionsFilter implements ExceptionFilter {
  constructor(private readonly httpAdapterHost: HttpAdapterHost) {}

  catch(exception: unknown, host: ArgumentsHost): void {
    const { httpAdapter } = this.httpAdapterHost;
    const ctx = host.switchToHttp();

    if (exception instanceof ApiHttpException) {
      const response = exception.getResponse();
      const responseBody: ApiResponse<null> = response as ApiResponse<null>;

      httpAdapter.reply(ctx.getResponse(), responseBody, exception.getStatus());
      return;
    }

    // For unhandled exceptions, return a generic server error response
    const responseBody: ApiResponse<null> = {
      data: null,
      error: {
        code: ApiErrorCode.SERVER_ERROR,
      },
    };

    httpAdapter.reply(
      ctx.getResponse(),
      responseBody,
      HttpStatus.INTERNAL_SERVER_ERROR,
    );
  }
}
