import { IsEmail, IsEnum, IsOptional, IsString } from 'class-validator';
import { UserStatus } from '../user-status.enum';

export class UserUpdateRequest {
  @IsOptional()
  @IsEmail()
  email?: string | null;

  @IsOptional()
  @IsString()
  firstName?: string;

  @IsOptional()
  @IsString()
  lastName?: string;

  @IsOptional()
  @IsString()
  profileImageUrl?: string | null;

  @IsOptional()
  @IsEnum(UserStatus)
  status?: UserStatus;
}
