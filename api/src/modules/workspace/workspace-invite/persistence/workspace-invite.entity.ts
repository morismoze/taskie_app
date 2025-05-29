import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { Column, Entity, JoinColumn, ManyToOne } from 'typeorm';
import { WorkspaceEntity } from '../../workspace-module/persistence/workspace.entity';
import { WorkspaceUserEntity } from '../../workspace-user-module/persistence/workspace-user.entity';

/**
 * Workspace invites are one-time invites - can be used only once
 * inside a time period defined by expiresAt
 */

@Entity({ name: 'workspace_invite' })
export class WorkspaceInviteEntity extends RootBaseEntity {
  @ManyToOne(() => WorkspaceEntity, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'workspace_id' })
  workspace!: WorkspaceEntity;

  @Column({ type: 'varchar' })
  token!: string;

  @Column({ type: 'timestamptz', name: 'expires_at' })
  expiresAt!: string;

  @ManyToOne(() => WorkspaceUserEntity, {
    onDelete: 'SET NULL',
    nullable: true,
  })
  @JoinColumn({ name: 'created_by_id' })
  createdBy!: WorkspaceUserEntity | null;

  @ManyToOne(() => WorkspaceUserEntity, {
    onDelete: 'SET NULL',
    nullable: true,
  })
  @JoinColumn({ name: 'used_by_id' })
  usedBy!: WorkspaceUserEntity | null;
}
