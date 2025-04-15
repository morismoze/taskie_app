import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { User } from 'src/modules/user/user-module/persistence/user.entity';
import { WorkspaceRole } from 'src/modules/workspace/role-module/persistence/workspace-role.entity';
import { Entity, ManyToOne } from 'typeorm';
import { Workspace } from './workspace.entity';

/**
 * This entity represents user's presence in a one workspace.
 * The logic is:
 * 1. A Workspace has many WorkspaceMembers
 * 2. A WorkspaceMember belongs to one Workspace
 *
 * If we would just put User[] entity as members in workspace
 * we would lose information like what role that user has in that
 * workspace, when the user has joined that workspace (createdAt), etc.
 */

@Entity()
export class WorkspaceMember extends RootBaseEntity {
  @ManyToOne(() => Workspace, (ws) => ws.members)
  workspace: Workspace;

  @ManyToOne(() => User)
  user: User;

  @ManyToOne(() => WorkspaceRole)
  role: WorkspaceRole;
}
