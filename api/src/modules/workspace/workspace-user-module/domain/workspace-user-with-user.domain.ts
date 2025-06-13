import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceUserCore } from './workspace-user-core.domain';

export interface WorkspaceUserWithUser extends WorkspaceUserCore {
  user: User;
}
