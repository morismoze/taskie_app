import { UserDto } from 'src/modules/user/user-module/types/user.dto';

export type LoginResponse = {
  accessToken: string;
  refreshToken: string;
  tokenExpires: number;
  user: UserDto;
};
