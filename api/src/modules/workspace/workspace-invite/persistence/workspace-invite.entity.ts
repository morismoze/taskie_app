import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { Column, Entity, JoinColumn, ManyToOne } from 'typeorm';
import { WorkspaceEntity } from '../../workspace-module/persistence/workspace.entity';
import { WorkspaceUserEntity } from '../../workspace-user-module/persistence/workspace-user.entity';
import { WorkspaceInviteStatus } from '../domain/workspace-invite-status.enum';

/**
 * Workspace invites are one-time invites - can be used only once
 * inside a time period defined by expiresAt
 */

@Entity({ name: 'workspace_invite' })
export class WorkspaceInviteEntity extends RootBaseEntity {
  @ManyToOne(() => WorkspaceEntity)
  @JoinColumn({ name: 'workspace_id' })
  workspace!: WorkspaceEntity;

  @Column()
  token!: string;

  @Column({ type: 'timestamp', name: 'expires_at' })
  expiresAt!: Date;

  @ManyToOne(() => WorkspaceUserEntity)
  @JoinColumn({ name: 'invited_by_id' })
  createdBy!: WorkspaceUserEntity;

  @ManyToOne(() => UserEntity, { nullable: true })
  @JoinColumn({ name: 'used_by_id' })
  usedBy!: UserEntity | null;

  @Column({
    type: 'enum',
    enum: WorkspaceInviteStatus,
    default: WorkspaceInviteStatus.ACTIVE,
  })
  status!: WorkspaceInviteStatus;
}
