import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { TaskEntity } from 'src/modules/task/task-module/persistence/task.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import {
  Column,
  Entity,
  JoinColumn,
  JoinTable,
  ManyToMany,
  ManyToOne,
  OneToMany,
} from 'typeorm';
import { ProgressStatus } from '../../task-module/domain/progress-status.enum';
import { GoalType } from '../domain/goal-type.enum';

/**
 * Represents a goal within a workspace. Goals can be:
 * 1. TASK_BASED — completed when all associated tasks are completed.
 * 2. POINTS_BASED — completed when requiredPoints are accumulated (sum of WorkspaceUser.totalRewardPoints = requiredPoints).
 */
@Entity()
export class GoalEntity extends RootBaseEntity {
  @OneToMany(() => WorkspaceUserEntity, (assignee) => assignee.workspace, {
    cascade: true,
  })
  assignees: WorkspaceUserEntity[];

  @ManyToOne(() => WorkspaceEntity)
  workspace: WorkspaceEntity; // Workspace this goal belongs to

  @Column()
  rewardTitle: string; // Title of the goal, basically represents string reward

  @Column({ nullable: true })
  description: string | null; // Optional goal description

  @Column({ name: 'required_points', nullable: true })
  // Points required for completion (only for POINTS_BASED goals)
  // This is only for
  requiredPoints: number | null;

  @ManyToMany(() => TaskEntity, { nullable: true })
  @JoinTable()
  tasks: TaskEntity[] | null; // Tasks associated with this goal (only for TASK_BASED goals)

  @Column({
    type: 'enum',
    enum: GoalType,
  })
  type: GoalType; // Type of goal (TASK_BASED or POINTS_BASED)

  @Column({
    type: 'enum',
    enum: ProgressStatus,
    default: ProgressStatus.IN_PROGRESS,
  })
  status: ProgressStatus; // Current status of the goal

  @ManyToOne(() => WorkspaceUserEntity)
  @JoinColumn({ name: 'created_by' })
  createdBy: WorkspaceUserEntity; // The user who created this goal
}
