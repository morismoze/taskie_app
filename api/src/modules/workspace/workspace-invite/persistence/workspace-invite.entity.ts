import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { Column, Entity, JoinColumn, ManyToOne } from 'typeorm';
import { WorkspaceEntity } from '../../workspace-module/persistence/workspace.entity';
import { WorkspaceInviteStatus } from '../domain/workspace-invite-status.enum';

/**
 * Workspace invites are one-time invites - can be used only once
 */

@Entity({ name: 'workspace_invite' })
export class WorkspaceInviteEntity extends RootBaseEntity {
  @ManyToOne(() => WorkspaceEntity)
  @JoinColumn({ name: 'workspace_id' })
  workspace!: WorkspaceEntity;

  @Column()
  token!: string;

  @Column({
    type: 'enum',
    enum: WorkspaceInviteStatus,
    default: WorkspaceInviteStatus.ACTIVE,
  })
  status!: WorkspaceInviteStatus;
}
