import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { Column, Entity, Index, ManyToOne, Unique } from 'typeorm';
import { WorkspaceEntity } from '../../workspace-module/persistence/workspace.entity';
import { WorkspaceUserRole } from '../domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from '../domain/workspace-user-status.enum';

/**
 * Represents a user's membership in a specific workspace.
 * Captures role and user-specific data within a workspace context.
 * We have composite unique constraint on both user and workspace, because
 * we don't want the same user to be defined multiple times as a workspace
 * user within the same workspace.
 */
@Entity()
@Unique('UQ_workspace_user', ['user', 'workspace'])
export class WorkspaceUserEntity extends RootBaseEntity {
  @Index()
  @ManyToOne(() => WorkspaceEntity)
  workspace: WorkspaceEntity;

  @Index()
  @ManyToOne(() => UserEntity)
  user: UserEntity;

  // if a role ever gets more granular (permissions, descriptions, etc.) this can
  // be implemented as separate WorkspaceRole entity
  @Index({ unique: true })
  @Column({
    name: 'workspace_role',
    type: 'enum',
    enum: WorkspaceUserRole,
  })
  workspaceRole: WorkspaceUserRole;

  @Column({
    type: 'enum',
    enum: WorkspaceUserStatus,
  })
  status: WorkspaceUserStatus;
}
