import { Exclude, Expose } from 'class-transformer';
import { IsEnum } from 'class-validator';
import { ERROR_CODES } from 'src/exception/error-codes';
import { StatusEnum } from '../status.enum';

@Exclude()
export class StatusDto {
  @Expose()
  @IsEnum(StatusEnum, { message: ERROR_CODES.INVALID_STATUS.message })
  name: string;
}
