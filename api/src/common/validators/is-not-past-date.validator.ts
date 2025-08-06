import {
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';
import { DateTime } from 'luxon';

@ValidatorConstraint({ name: 'IsNotPastIsoDateTime' })
export class IsNotPastIsoDateConstraint
  implements ValidatorConstraintInterface
{
  validate(dateTimeIsoString: string) {
    const dueDate = DateTime.fromISO(dateTimeIsoString).toUTC();
    const nowUtc = DateTime.now().toUTC();

    return dueDate >= nowUtc;
  }
}
