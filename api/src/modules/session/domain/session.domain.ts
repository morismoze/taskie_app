import { RootDomain } from 'src/modules/database/domain/root.domain';
import { User } from 'src/modules/user/domain/user.domain';

export interface Session extends RootDomain {
  user: User;
  hash: string;
  ipAddress: string;
  deviceModel: string | null;
  osVersion: string | null;
  appVersion: string | null;
  buildNumber: string | null;
  accessTokenVersion: number;
}
