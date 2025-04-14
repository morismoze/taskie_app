import { ApiErrorCode } from '../../exception/api-error-code.enum';

interface ApiError {
  code: ApiErrorCode;
  context?: string;
}

export type ApiResponse<D> =
  | {
      data: D;
      error: null;
    }
  | {
      data: null;
      error: ApiError;
    };
