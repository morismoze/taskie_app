import { UserResponse } from 'src/modules/user/dto/user-response.dto';

export interface LoginResponse {
  accessToken: string;
  refreshToken: string;
  tokenExpires: number;
  user: UserResponse;
}
