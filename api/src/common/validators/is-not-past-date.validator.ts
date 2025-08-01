import {
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';
import { DateTime } from 'luxon';

@ValidatorConstraint({ name: 'IsNotPastIsoDateTime' })
export class IsNotPastIsoDateTimeConstraint
  implements ValidatorConstraintInterface
{
  validate(dateTimeIsoString: string) {
    const dueDate = DateTime.fromISO(dateTimeIsoString, { zone: 'utc' });
    const nowUtc = DateTime.now().toUTC();

    return dueDate >= nowUtc;
  }
}
