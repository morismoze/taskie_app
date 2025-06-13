import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { GoalEntity } from 'src/modules/goal/persistence/goal.entity';
import { TaskAssignmentEntity } from 'src/modules/task/task-assignment/persistence/task-assignment.entity';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  Unique,
} from 'typeorm';
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
@Entity({ name: 'workspace_user' })
@Unique('UQ_workspace_user', ['user', 'workspace'])
export class WorkspaceUserEntity extends RootBaseEntity {
  @Index()
  @ManyToOne(() => WorkspaceEntity, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'workspace_id' })
  workspace!: WorkspaceEntity;

  @Index()
  @ManyToOne(() => UserEntity, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user!: UserEntity;

  // if a role ever gets more granular (permissions, descriptions, etc.) this can
  // be implemented as separate WorkspaceRole entity
  @Column({
    name: 'workspace_role',
    type: 'enum',
    enum: WorkspaceUserRole,
  })
  workspaceRole!: WorkspaceUserRole;

  @Column({
    type: 'enum',
    enum: WorkspaceUserStatus,
  })
  status!: WorkspaceUserStatus;

  // The user who created this WorkspaceUser
  // Applicable in cases:
  // 1. when virtual workspace users are created
  // 2. when concrete workspace users are created when a user joins a workspace by invite link
  // It is null in the case when user creates a workspace, and is automatically defined
  // as the first workspace user of that workspace
  @ManyToOne(() => WorkspaceUserEntity, {
    nullable: true,
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'created_by_id' })
  createdBy!: WorkspaceUserEntity | null;

  @OneToMany(() => GoalEntity, (goal) => goal.assignee)
  goals!: GoalEntity[];

  @OneToMany(
    () => TaskAssignmentEntity,
    (taskAssignment) => taskAssignment.assignee,
  )
  taskAssignments!: TaskAssignmentEntity[];
}
