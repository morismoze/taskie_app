import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { Task } from 'src/modules/task/task-module/persistence/task.entity';
import { Workspace } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { WorkspaceUser } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import {
  Column,
  Entity,
  JoinTable,
  ManyToMany,
  ManyToOne,
  OneToMany,
} from 'typeorm';
import { ProgressStatus } from '../../progress-status.enum';
import { GoalType } from '../goal-type.enum';

/**
 * Represents a goal within a workspace. Goals can be:
 * 1. TASK_BASED — completed when all associated tasks are completed.
 * 2. POINTS_BASED — completed when requiredPoints are accumulated (sum of WorkspaceUser.totalRewardPoints = requiredPoints).
 */
@Entity()
export class Goal extends RootBaseEntity {
  @OneToMany(() => WorkspaceUser, (assignee) => assignee.workspace, {
    cascade: true,
  })
  assignees: WorkspaceUser[];

  @ManyToOne(() => WorkspaceUser)
  createdBy: WorkspaceUser; // The user who created this goal

  @Column({ nullable: true })
  description: string | null; // Optional goal description

  @Column({ nullable: true })
  requiredPoints: number | null; // Points required for completion (only for POINTS_BASED goals)

  @Column()
  reward: string; // Reward description upon goal completion

  @Column({
    type: 'enum',
    enum: ProgressStatus,
    default: ProgressStatus.IN_PROGRESS,
  })
  status: ProgressStatus; // Current status of the goal

  @ManyToMany(() => Task, { nullable: true })
  @JoinTable()
  tasks: Task[] | null; // Tasks associated with this goal (only for TASK_BASED goals)

  @Column({
    type: 'enum',
    enum: GoalType,
  })
  type: GoalType; // Type of goal (TASK_BASED or POINTS_BASED)

  @ManyToOne(() => Workspace, (ws) => ws.goals, { nullable: false })
  workspace: Workspace; // Workspace this goal belongs to
}
