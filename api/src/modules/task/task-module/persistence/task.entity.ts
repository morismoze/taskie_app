import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { GoalEntity } from 'src/modules/task/goal-module/persistence/goal.entity';
import { Workspace } from 'src/modules/workspace/persistence/workspace.entity';
import { Column, Entity, ManyToOne, OneToMany } from 'typeorm';
import { ProgressStatus } from 'src/modules/task/progress-status.enum';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { WorkspaceUser } from 'src/modules/workspace/workspace-role-module/persistence/workspace-member.entity';

/**
 * Represents a task that can either be part of a goal or act as a standalone goal.
 */
@Entity()
export class Task extends RootBaseEntity {
  @OneToMany(() => WorkspaceUser, (assignee) => assignee.workspace, {
    cascade: true,
  })
  assignees: WorkspaceUser[]; // Single task can be assigned to multiple WorkspaceUsers

  @ManyToOne(() => UserEntity)
  createdBy: WorkspaceUser;

  @Column({ nullable: true })
  description: string | null; // Description of the task

  @Column({ nullable: true })
  reward: string | null; // Reward description for standalone tasks

  @ManyToOne(() => GoalEntity, { nullable: true })
  goal: GoalEntity | null; // Links task to a goal if not a standalone task

  @Column({ default: 0 })
  rewardPoints: number; // Points assigned to this task when completed

  @Column({
    type: 'enum',
    enum: ProgressStatus,
    default: ProgressStatus.IN_PROGRESS,
  })
  status: ProgressStatus; // Current status of the task

  @Column()
  title: string; // Title of the task

  @ManyToOne(() => Workspace, { nullable: false })
  workspace: Workspace; // Workspace the task belongs to
}
