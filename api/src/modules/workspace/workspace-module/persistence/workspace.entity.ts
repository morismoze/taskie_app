import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { Goal } from 'src/modules/task/goal-module/persistence/goal.entity';
import { Task } from 'src/modules/task/task-module/persistence/task.entity';
import { User } from 'src/modules/user/persistence/user.entity';
import { Column, Entity, ManyToOne, OneToMany } from 'typeorm';
import { WorkspaceUser } from '../../workspace-user-module/persistence/workspace-user.entity';

/**
 * Represents a workspace that contains members, goals, and standalone tasks.
 */
@Entity()
export class Workspace extends RootBaseEntity {
  @ManyToOne(() => User, { nullable: false })
  owner: User;

  @OneToMany(() => Goal, (goal) => goal.workspace)
  goals: Goal[];

  @OneToMany(() => WorkspaceUser, (wm) => wm.workspace)
  members: WorkspaceUser[];

  @Column()
  name: string;

  @OneToMany(() => Task, (t) => t.workspace)
  standaloneTasks: Task[];
}
