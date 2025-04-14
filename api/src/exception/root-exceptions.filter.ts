import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { HttpAdapterHost } from '@nestjs/core';
import { ApiResponse } from 'src/common/types/api-response.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from './ApiHttpException.model';

@Catch()
export class RootExceptionsFilter implements ExceptionFilter {
  constructor(private readonly httpAdapterHost: HttpAdapterHost) {}

  catch(exception: unknown, host: ArgumentsHost): void {
    const { httpAdapter } = this.httpAdapterHost;
    const ctx = host.switchToHttp();

    if (exception instanceof ApiHttpException) {
      httpAdapter.reply(
        ctx.getResponse(),
        exception.getResponse(),
        exception.getStatus(),
      );
      return;
    }

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
