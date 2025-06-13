import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { Column, Entity, JoinColumn, ManyToOne } from 'typeorm';
import { ProgressStatus } from '../../task/task-module/domain/progress-status.enum';

/**
 * Represents a goal within a workspace. Goals are POINTS_BASED, meaning
 * completed when requiredPoints are accumulated (sum of WorkspaceUser.totalRewardPoints = requiredPoints).
 */
@Entity({ name: 'goal' })
export class GoalEntity extends RootBaseEntity {
  @ManyToOne(() => WorkspaceUserEntity, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'assignee_id' })
  assignee!: WorkspaceUserEntity;

  @ManyToOne(() => WorkspaceEntity, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'workspace_id' })
  workspace!: WorkspaceEntity; // Workspace this goal belongs to

  @Column({ type: 'varchar' })
  title!: string; // Title of the goal, basically represents string reward

  @Column({ type: 'varchar', nullable: true })
  description!: string | null; // Optional goal description

  @Column({ type: 'integer', name: 'required_points' })
  requiredPoints!: number;

  @Column({
    type: 'enum',
    enum: ProgressStatus,
    default: ProgressStatus.IN_PROGRESS,
  })
  status!: ProgressStatus; // Current status of the goal

  @ManyToOne(() => WorkspaceUserEntity, {
    onDelete: 'SET NULL',
    nullable: true,
  })
  @JoinColumn({ name: 'created_by_id' })
  createdBy!: WorkspaceUserEntity | null; // The user who created this goal
}
