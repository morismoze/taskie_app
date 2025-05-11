import { HttpException } from '@nestjs/common';
import { ApiError } from 'src/common/types/api-response.type';

export class ApiHttpException extends HttpException {
  constructor(error: ApiError, status: number) {
    super(error, status);
  }
}
