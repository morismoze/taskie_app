import { IsString } from 'class-validator';

export class AuthGoogleRequest {
  @IsString()
  idToken: string;
}
