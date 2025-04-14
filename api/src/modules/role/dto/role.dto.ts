import { Exclude, Expose } from 'class-transformer';
import { IsEnum } from 'class-validator';
import { ERROR_CODES } from 'src/exception/error-codes';
import { RoleEnum } from '../role.enum';

@Exclude()
export class RoleDto {
  @Expose()
  @IsEnum(RoleEnum, { message: ERROR_CODES.INVALID_ROLE.message })
  name: string;
}
