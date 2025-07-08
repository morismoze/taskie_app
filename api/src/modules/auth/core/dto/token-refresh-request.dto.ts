import { IsJWT, IsNotEmpty, IsString } from 'class-validator';

export class TokenRefreshRequest {
  // This is used in the jwt-refresh strategy
  static readonly REFRESH_TOKEN_FIELD_NAME = 'refreshToken';

  @IsNotEmpty()
  @IsString()
  @IsJWT()
  refreshToken: string;

  constructor(refreshToken: string) {
    this.refreshToken = refreshToken;
  }
}
