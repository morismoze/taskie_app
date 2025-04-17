import { HttpException } from '@nestjs/common';
import { ApiError, ApiResponse } from 'src/common/types/api-response.type';

export class ApiHttpException extends HttpException {
  constructor(error: ApiError, status: number) {
    super(
      {
        data: null,
        error,
      } as ApiResponse<null>,
      status,
    );
  }
}
