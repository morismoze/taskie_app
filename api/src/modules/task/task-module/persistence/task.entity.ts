import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { Goal } from 'src/modules/task/goal-module/persistence/goal.entity';
import { Workspace } from 'src/modules/workspace/role-module/persistence/workspace.entity';
import { Column, Entity, ManyToOne, OneToMany } from 'typeorm';
import { ProgressStatus } from 'src/modules/task/task-module/progress-status.enum';
import { User } from 'src/modules/user/user-module/persistence/user.entity';
import { WorkspaceMember } from 'src/modules/workspace/role-module/persistence/workspace-member.entity';

/**
 * Represents a task that can either be part of a goal or act as a standalone goal.
 */
@Entity()
export class Task extends RootBaseEntity {
  @OneToMany(() => WorkspaceMember, (assignee) => assignee.workspace, {
    cascade: true,
  })
  assignees: WorkspaceMember[]; // single task can be assigned to multiple WorkspaceMembers

  @ManyToOne(() => User)
  createdBy: WorkspaceMember;

  @Column({ nullable: true })
  description: string | null; // Description of the task

  @Column({ nullable: true })
  goalReward: string | null; // Reward description for standalone goals

  @ManyToOne(() => Goal, { nullable: true })
  goal: Goal | null; // Links task to a goal (if any)

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
