import { IsEmail, IsEnum, IsOptional, IsString } from 'class-validator';
import { UserStatus } from '../domain/user-status.enum';

export class UserUpdateRequest {
  @IsOptional()
  @IsEmail()
  email?: string;

  @IsOptional()
  @IsString()
  firstName?: string;

  @IsOptional()
  @IsString()
  lastName?: string;

  @IsOptional()
  @IsString()
  profileImageUrl?: string;

  @IsOptional()
  @IsEnum(UserStatus)
  status?: UserStatus;
}
