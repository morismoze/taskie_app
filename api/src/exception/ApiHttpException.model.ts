import { HttpException } from '@nestjs/common';
import { ApiResponse } from 'src/common/types/api-response.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';

export class ApiHttpException extends HttpException {
  constructor(message: ApiErrorCode, status: number) {
    super(
      {
        data: null,
        error: message,
      } as ApiResponse<null>,
      status,
    );
  }
}
