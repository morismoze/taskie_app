import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { GoalEntity } from 'src/modules/task/goal-module/persistence/goal.entity';
import { Column, Entity, JoinColumn, ManyToOne, OneToMany } from 'typeorm';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';

/**
 * Represents a task that can either be part of a goal or act as a standalone goal.
 */
@Entity()
export class TaskEntity extends RootBaseEntity {
  @OneToMany(() => WorkspaceUserEntity, (assignee) => assignee.workspace, {
    cascade: true,
  })
  assignees: WorkspaceUserEntity[]; // Single task can be assigned to multiple WorkspaceUsers

  @ManyToOne(() => UserEntity)
  @JoinColumn({ name: 'created_by' })
  createdBy: WorkspaceUserEntity;

  @Column({ nullable: true })
  description: string | null; // Description of the task

  @Column({ nullable: true })
  reward: string | null; // Reward description for standalone tasks

  @ManyToOne(() => GoalEntity, { nullable: true })
  goal: GoalEntity | null; // Links task to a goal if not a standalone task

  @Column({ name: 'reward_points' })
  rewardPoints: number; // Points assigned to this task when completed

  @Column({
    type: 'enum',
    enum: ProgressStatus,
    default: ProgressStatus.IN_PROGRESS,
  })
  status: ProgressStatus; // Current status of the task

  @Column()
  title: string; // Title of the task

  @ManyToOne(() => WorkspaceEntity, { nullable: false })
  workspace: WorkspaceEntity; // Workspace the task belongs to
}
