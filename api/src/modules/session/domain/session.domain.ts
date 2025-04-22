import { User } from 'src/modules/user/domain/user.domain';

export class Session {
  id: string;
  user: User;
  hash: string;
  ipAddress: string;
  deviceId: string | null;
  deviceModel: string | null;
  osVersion: string | null;
  appVersion: string | null;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
}
