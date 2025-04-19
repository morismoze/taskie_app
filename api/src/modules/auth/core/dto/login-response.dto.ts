import { UserResponse } from 'src/modules/user/dto/user.dto';

export type LoginResponse = {
  accessToken: string;
  refreshToken: string;
  tokenExpires: number;
  user: UserResponse;
};
