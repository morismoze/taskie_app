import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceCore } from './workspace-core.domain';

export interface WorkspaceWithCreatedByUser extends WorkspaceCore {
  createdBy: User | null;
}
