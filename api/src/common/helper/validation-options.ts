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

const formatErrors = (errors: ValidationError[]) => {
  return errors.map((err) => ({
    property: err.property,
    errors: err.constraints,
    children: err.children?.length ? formatErrors(err.children) : undefined,
  }));
};

const getValidationOptions = (
  configService: ConfigService<AggregatedConfig>,
  logger: AppLogger,
): ValidationPipeOptions => ({
  enableDebugMessages:
    configService.getOrThrow('app.nodeEnv', { infer: true }) !==
    Environment.DEVELOPMENT
      ? true
      : false,
  transform: true,
  // Strip validated (returned) object of any properties that do not use any validation decorators
  whitelist: true,
  errorHttpStatusCode: HttpStatus.UNPROCESSABLE_ENTITY,
  exceptionFactory: (errors: ValidationError[]) => {
    const formattedErrors = formatErrors(errors);
    // Logging validation exceptions also on the prod
    // because we want to know if there is discrepancy
    // between frontend and backend validation
    logger.warn(
      {
        msg: 'Validation failed',
        validationErrors: formattedErrors,
      },
      'ValidationPipe',
    );

    return new ApiHttpException(
      {
        code: ApiErrorCode.INVALID_PAYLOAD,
      },
      HttpStatus.UNPROCESSABLE_ENTITY,
    );
  },
});

export default getValidationOptions;
