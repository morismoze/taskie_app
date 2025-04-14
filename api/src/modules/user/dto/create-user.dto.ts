import { Transform, Type } from 'class-transformer';
import { IsEmail, IsNotEmpty, IsOptional, MinLength } from 'class-validator';
import { ERROR_CODES } from 'src/exception/error-codes';
import { lowerCaseTransformer } from 'src/common/transformers/lower-case.transformer';
import { RoleDto } from 'src/modules/role/dto/role.dto';
import { StatusDto } from 'src/modules/status/dto/status.dto';

export class CreateUserDto {
  @Transform(lowerCaseTransformer)
  @IsEmail({}, { message: ERROR_CODES.INVALID_EMAIL.message })
  email: string;

  @MinLength(6, { message: ERROR_CODES.INVALID_PASSWORD.message })
  password: string;

  @IsNotEmpty({ message: ERROR_CODES.REQUIRED_FIELD.message })
  firstName: string;

  @IsNotEmpty({ message: ERROR_CODES.REQUIRED_FIELD.message })
  lastName: string;

  @IsOptional()
  @Type(() => RoleDto)
  role?: RoleDto;

  @IsOptional()
  @Type(() => StatusDto)
  status?: StatusDto;
}
