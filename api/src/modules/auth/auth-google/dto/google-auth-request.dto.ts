import { IsNotEmpty, IsString } from 'class-validator';

export class AuthGoogleRequest {
  @IsNotEmpty()
  @IsString()
  idToken: string;

  constructor(idToken: string) {
    this.idToken = idToken;
  }
}
