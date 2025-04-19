import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { GoalEntity } from 'src/modules/task/goal-module/persistence/goal.entity';
import { Task } from 'src/modules/task/task-module/persistence/task.entity';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { Column, Entity, ManyToOne, OneToMany } from 'typeorm';
import { WorkspaceUser } from '../../workspace-user-module/persistence/workspace-user.entity';

/**
 * Represents a workspace that contains members, goals, and standalone tasks.
 */
@Entity()
export class WorkspaceEntity extends RootBaseEntity {
  @ManyToOne(() => UserEntity, { nullable: false })
  owner: UserEntity;

  @OneToMany(() => GoalEntity, (goal) => goal.workspace)
  goals: GoalEntity[];

  @OneToMany(() => WorkspaceUser, (wm) => wm.workspace)
  members: WorkspaceUser[];

  @Column()
  name: string;

  @OneToMany(() => Task, (t) => t.workspace)
  standaloneTasks: Task[];
}
