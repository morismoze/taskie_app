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
  @ManyToOne(() => WorkspaceUserEntity)
  @JoinColumn({ name: 'assignee_id' })
  assignee: WorkspaceUserEntity;

  @ManyToOne(() => WorkspaceEntity)
  @JoinColumn({ name: 'workspace_id' })
  workspace: WorkspaceEntity; // Workspace this goal belongs to

  @Column()
  reward: string; // Title of the goal, basically represents string reward

  @Column({ nullable: true })
  description: string | null; // Optional goal description

  @Column({ name: 'required_points', nullable: true })
  requiredPoints: number | null; // Points required for completion (only for POINTS_BASED goals)

  @ManyToMany(() => TaskEntity, (task) => task.goals, { nullable: true })
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
  @JoinColumn({ name: 'created_by_id' })
  createdBy: WorkspaceUserEntity; // The user who created this goal
}
