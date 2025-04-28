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

  @ManyToOne(() => WorkspaceEntity)
  workspace: WorkspaceEntity; // Workspace the task belongs to

  @Column()
  rewardTitle: string; // Title of the task, basically represents string reward

  @Column({ nullable: true })
  description: string | null; // Description of the task

  @ManyToOne(() => GoalEntity, { nullable: true })
  goal: GoalEntity[] | null; // Links task to a goal if not a standalone task (for TASK_BASED goals only)

  @Column({ name: 'reward_points' })
  rewardPoints: number; // Points assigned to this task when completed

  @Column({
    type: 'enum',
    enum: ProgressStatus,
    default: ProgressStatus.IN_PROGRESS,
  })
  status: ProgressStatus; // Current status of the task

  @ManyToOne(() => UserEntity)
  @JoinColumn({ name: 'created_by' })
  createdBy: WorkspaceUserEntity;
}
