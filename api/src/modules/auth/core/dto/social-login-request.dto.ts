import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class SocialLoginRequest {
  @ApiProperty({
    description: 'ID token from auth provider',
  })
  @IsNotEmpty()
  @IsString()
  idToken: string;

  constructor(idToken: string) {
    this.idToken = idToken;
  }
}
