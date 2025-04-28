import { AuthProvider } from 'src/modules/auth/core/domain/auth-provider.enum';
import { RootDomain } from 'src/modules/database/domain/root.domain';
import { UserStatus } from './user-status.enum';

export interface User extends RootDomain {
  email: string | null;
  firstName: string;
  lastName: string;
  profileImageUrl: string | null;
  provider: AuthProvider | null;
  socialId: string | null;
  status: UserStatus;
}
