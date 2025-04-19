import { AuthProvider } from 'src/modules/auth/core/domain/auth-provider.enum';
import { UserStatus } from '../user-status.enum';

export interface User {
  id: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
  email: string | null;
  firstName: string;
  lastName: string;
  profileImageUrl: string | null;
  provider: AuthProvider;
  socialId: string | null;
  status: UserStatus;
}
