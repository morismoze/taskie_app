import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { TaskAssignee } from 'src/modules/task/task-module/persistence/task-assignee.entity';
import { Goal } from 'src/modules/task/goal-module/persistence/goal.entity';
import { Workspace } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { Column, Entity, ManyToOne, OneToMany } from 'typeorm';
import { GoalStatus } from 'src/modules/task/goal-module/goal-status.enum';
import { User } from 'src/modules/user/user-module/persistence/user.entity';

@Entity()
export class Task extends RootBaseEntity {
  @Column()
  title: string;

  @Column({ nullable: true })
  description: string | null;

  // We reuse the same enum on both Goal and Task entities
  @Column({
    type: 'enum',
    enum: GoalStatus,
    default: GoalStatus.IN_PROGRESS,
  })
  status: GoalStatus;

  // this field is present in this entity only because of the case when task doesn't
  // belong to any goal, but acts a standalone goal
  @ManyToOne(() => Workspace, { nullable: false })
  workspace: Workspace;

  // this field can be null in the case task doesn't belong to any goal but acts a standalone goal
  @ManyToOne(() => Goal, { nullable: true })
  goal: Goal | null;

  // this field defines that a task can be assigned to more than one user
  @OneToMany(() => TaskAssignee, (assignee) => assignee.task, {
    cascade: true,
  })
  assignees: TaskAssignee[];

  @ManyToOne(() => User)
  createdBy: User;

  @Column({ default: false })
  isCompleted: boolean;

  @Column({ default: 0 })
  rewardPoints: number;

  // this field is used in the case when a task doesn't belong to any goal, but acts a standalone goal
  // so it must have standalone goal reward
  @Column({ nullable: true })
  goalReward: string | null;
}
