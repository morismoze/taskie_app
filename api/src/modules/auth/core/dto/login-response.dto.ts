import { UserResponse } from 'src/modules/user/dto/user-response.dto';

export type LoginResponse = {
  accessToken: string;
  refreshToken: string;
  tokenExpires: number;
  user: UserResponse;
};
