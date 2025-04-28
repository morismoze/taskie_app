import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { GoalEntity } from 'src/modules/task/goal-module/persistence/goal.entity';
import {
  Column,
  Entity,
  JoinColumn,
  ManyToMany,
  ManyToOne,
  OneToMany,
} from 'typeorm';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { TaskAssignmentEntity } from '../../task-assignment/persistence/task-assignment.entity';

/**
 * Represents a task that can either be part of a goal or act as a standalone goal.
 */
@Entity()
export class TaskEntity extends RootBaseEntity {
  @ManyToOne(() => WorkspaceEntity)
  @JoinColumn({ name: 'workspace_id' })
  workspace: WorkspaceEntity; // Workspace the task belongs to

  @Column()
  title: string;

  @Column({ name: 'reward_points' })
  rewardPoints: number;

  @Column({ nullable: true })
  description: string | null;

  @Column({ nullable: true })
  // Optional reward in case Manager wants to handle task as small reawarding task
  optionalReward: string | null;

  @ManyToMany(() => GoalEntity, (goal) => goal.tasks, { nullable: true })
  goals: GoalEntity[] | null;

  @OneToMany(
    () => TaskAssignmentEntity,
    (taskAssignment) => taskAssignment.task,
  )
  taskAssignments: TaskAssignmentEntity[];

  @ManyToOne(() => UserEntity)
  @JoinColumn({ name: 'created_by_id' })
  createdBy: WorkspaceUserEntity;
}
