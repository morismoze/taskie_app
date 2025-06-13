import { IsNotEmpty, IsString } from 'class-validator';

export class SocialLoginRequest {
  @IsNotEmpty()
  @IsString()
  idToken: string;

  constructor(idToken: string) {
    this.idToken = idToken;
  }
}
