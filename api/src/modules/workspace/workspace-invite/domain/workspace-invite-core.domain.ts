import { RootDomain } from 'src/modules/database/domain/root.domain';

export interface WorkspaceInviteCore extends RootDomain {
  token: string;
  expiresAt: string;
}
