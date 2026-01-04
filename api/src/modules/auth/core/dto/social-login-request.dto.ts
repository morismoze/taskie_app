import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class SocialLoginRequest {
  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  idToken: string;

  constructor(idToken: string) {
    this.idToken = idToken;
  }
}
