import { Transform } from 'class-transformer';
import { IsEmail, IsNotEmpty } from 'class-validator';
import { ERROR_CODES } from 'src/exception/error-codes';
import { lowerCaseTransformer } from 'src/common/transformers/lower-case.transformer';

export class LoginRequestDto {
  @Transform(lowerCaseTransformer)
  @IsNotEmpty()
  @IsEmail()
  email: string;

  @IsNotEmpty()
  password: string;
}
