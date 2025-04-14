import { Transform } from 'class-transformer';
import { IsEmail, IsNotEmpty, MinLength } from 'class-validator';
import { lowerCaseTransformer } from 'src/common/transformers/lower-case.transformer';

export class RegisterRequestDto {
  @Transform(lowerCaseTransformer)
  @IsEmail({}, { message: 'Provided value is invalid email' })
  email: string;

  @MinLength(6, { message: 'Password should have at least 6 characters' })
  password: string;

  @IsNotEmpty({ message: 'Firstname is missing' })
  firstName: string;

  @IsNotEmpty({ message: 'Lastname is missing' })
  lastName: string;
}
