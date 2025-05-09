import {
  ValidationArguments,
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';

@ValidatorConstraint({ name: 'IsMultipleOf' })
export class IsMultipleOfConstraint implements ValidatorConstraintInterface {
  validate(value: number, validationArguments: ValidationArguments) {
    return value % validationArguments.constraints[0] === 0;
  }
}
