import { ApiProperty } from '@nestjs/swagger';

export class TokenRefreshResponse {
  @ApiProperty()
  accessToken!: string;

  @ApiProperty()
  refreshToken!: string;

  @ApiProperty()
  tokenExpires!: number;
}
