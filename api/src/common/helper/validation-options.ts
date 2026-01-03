import {
  HttpStatus,
  ValidationError,
  ValidationPipeOptions,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Environment } from 'src/config/app.config';
import { AggregatedConfig } from 'src/config/config.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { AppLogger } from 'src/modules/logger/app-logger';

const getValidationOptions = (
  configService: ConfigService<AggregatedConfig>,
  logger: AppLogger,
): ValidationPipeOptions => ({
  enableDebugMessages:
    configService.getOrThrow('app.nodeEnv', { infer: true }) !==
    Environment.PRODUCTION
      ? true
      : false,
  transform: true,
  whitelist: true,
  errorHttpStatusCode: HttpStatus.UNPROCESSABLE_ENTITY,
  exceptionFactory: (errors: ValidationError[]) => {
    logger.error({ message: errors.toString(), context: 'ValidationPipe' });

    return new ApiHttpException(
      {
        code: ApiErrorCode.INVALID_PAYLOAD,
      },
      HttpStatus.UNPROCESSABLE_ENTITY,
    );
  },
});

export default getValidationOptions;
