import { User } from 'src/modules/user/persistence/user.entity';

export type JwtPayload = Pick<User, 'role'> & {
  sub: string;
  iat: number;
  exp: number;
};
