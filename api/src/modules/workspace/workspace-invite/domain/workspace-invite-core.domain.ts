import { RootDomain } from 'src/modules/database/domain/root.domain';
import { WorkspaceInviteStatus } from './workspace-invite-status.enum';

export interface WorkspaceInviteCore extends RootDomain {
  token: string;
  expiresAt: Date;
  status: WorkspaceInviteStatus;
}
