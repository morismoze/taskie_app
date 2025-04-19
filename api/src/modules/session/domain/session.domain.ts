import { User } from 'src/modules/user/domain/user.domain';

export interface Session {
  id: string;
  user: User;
  hash: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date;
}
