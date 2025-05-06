import { RootDomain } from 'src/modules/database/domain/root.domain';

export interface SessionCore extends RootDomain {
  hash: string;
  ipAddress: string;
  deviceId: string | null;
  deviceModel: string | null;
  osVersion: string | null;
  appVersion: string | null;
}
