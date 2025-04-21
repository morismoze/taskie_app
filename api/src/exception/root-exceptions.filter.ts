import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpStatus,
  HttpException,
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
      const response = exception.getResponse();
      const responseBody: ApiResponse<null> = response as ApiResponse<null>;

      httpAdapter.reply(ctx.getResponse(), responseBody, exception.getStatus());
      return;
    }

    // For any other known thrown exceptions like: NotFoundException, InternalServerErrorException, UnauthorizedException
    if (exception instanceof HttpException) {
      const response = ctx.getResponse();
      httpAdapter.reply(response, undefined, response.getStatus());
      return;
    }

    httpAdapter.reply(
      ctx.getResponse(),
      undefined,
      HttpStatus.INTERNAL_SERVER_ERROR,
    );
  }
}
