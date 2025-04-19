import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { UserStatus } from 'src/modules/user/user-status.enum';
import { Column, Entity, Index, ManyToOne } from 'typeorm';
import { WorkspaceEntity } from '../../workspace-module/persistence/workspace.entity';
import { WorkspaceUserRole } from '../domain/workspace-user-role.enum';

/**
 * Represents a user's membership in a specific workspace.
 * Captures role and user-specific data within a workspace context.
 */
@Entity()
export class WorkspaceUser extends RootBaseEntity {
  @Index()
  @ManyToOne(() => WorkspaceEntity)
  workspace: WorkspaceEntity;

  @Index()
  @ManyToOne(() => UserEntity)
  user: UserEntity;

  // if a role ever gets more granular (permissions, descriptions, etc.) this can
  // be implemented as separete WorkspaceRole entity
  @Index({ unique: true })
  @Column({
    type: 'enum',
    enum: WorkspaceUserRole,
  })
  workspaceRole: WorkspaceUserRole;

  @Column({
    type: 'enum',
    enum: UserStatus,
    default: UserStatus.ACTIVE,
  })
  status: UserStatus;
}
