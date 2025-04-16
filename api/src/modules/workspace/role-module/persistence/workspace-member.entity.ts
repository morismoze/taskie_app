import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { User } from 'src/modules/user/user-module/persistence/user.entity';
import { Column, Entity, Index, ManyToOne } from 'typeorm';
import { WorkspaceMemberRole } from '../../role-module/workspace-role.enum';
import { Workspace } from './workspace.entity';

/**
 * Represents a user's membership in a specific workspace.
 * Captures role and user-specific data within a workspace context.
 */
@Entity()
export class WorkspaceMember extends RootBaseEntity {
  @Index()
  @ManyToOne(() => Workspace)
  workspace: Workspace;

  @Index()
  @ManyToOne(() => User)
  user: User;

  // if a role ever gets more granular (permissions, descriptions, etc.) this can
  // be implemented as separete WorkspaceRole entity
  @Index({ unique: true })
  @Column({
    type: 'enum',
    enum: WorkspaceMemberRole,
  })
  workspaceRole: string;
}
