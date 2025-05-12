import {
  HttpStatus,
  Logger,
  ValidationError,
  ValidationPipeOptions,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Environment } from 'src/config/app.config';
import { AggregatedConfig } from 'src/config/config.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/ApiHttpException.type';

const getValidationOptions = (
  configService: ConfigService<AggregatedConfig>,
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
    const logger = new Logger('ValidationPipe');
    logger.error(errors.toString());

    return new ApiHttpException(
      {
        code: ApiErrorCode.INVALID_PAYLOAD,
      },
      HttpStatus.UNPROCESSABLE_ENTITY,
    );
  },
});

export default getValidationOptions;
