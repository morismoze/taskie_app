import {
  HttpException,
  HttpStatus,
  ValidationError,
  ValidationPipeOptions,
} from '@nestjs/common';

function generateErrors(errors: ValidationError[]) {
  return errors.reduce(
    (accumulator, currentValue) => [
      ...accumulator,
      {
        field: currentValue.property,
        message:
          (currentValue.children?.length ?? 0) > 0
            ? generateErrors(currentValue.children ?? [])
            : Object.values(currentValue.constraints ?? {}).join('. '),
      },
    ],
    [],
  );
}

const validationOptions: ValidationPipeOptions = {
  transform: true,
  whitelist: true,
  errorHttpStatusCode: HttpStatus.UNPROCESSABLE_ENTITY,
  exceptionFactory: (errors: ValidationError[]) => {
    return new HttpException(
      {
        isSuccess: false,
        data: null,
        errors: generateErrors(errors),
      },
      HttpStatus.UNPROCESSABLE_ENTITY,
    );
  },
};

export default validationOptions;
