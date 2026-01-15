import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ApiErrorCode } from '../../exception/api-error-code.enum';

export class ApiError {
  @ApiProperty({
    enum: ApiErrorCode,
    description: 'Internal error code',
  })
  code!: ApiErrorCode;

  @ApiPropertyOptional()
  context?: string;
}

export class ApiErrorResponse {
  @ApiProperty({ example: null, nullable: true })
  data!: null;

  @ApiProperty({ type: ApiError })
  error!: ApiError;
}

export class ApiSuccessResponse<D> {
  @ApiProperty()
  data!: D;

  @ApiProperty({ nullable: true, example: null })
  error!: null;
}

export type ApiResponse<D> = ApiSuccessResponse<D> | ApiErrorResponse;
