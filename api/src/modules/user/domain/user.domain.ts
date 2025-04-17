import { AuthProvider } from 'src/modules/auth/core/domain/auth-provider.enum';
import { UserStatus } from '../user-status.enum';

export interface UserDomain {
  id: string;
  createdAt: Date;
  email: string | null;
  firstName: string;
  lastName: string;
  profileImageUrl: string | null;
  provider: AuthProvider;
  socialId: string | null;
  status: UserStatus;
}
