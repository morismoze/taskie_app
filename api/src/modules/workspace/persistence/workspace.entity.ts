import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { Goal } from 'src/modules/task/goal-module/persistence/goal.entity';
import { Task } from 'src/modules/task/task-module/persistence/task.entity';
import { Column, Entity, OneToMany } from 'typeorm';
import { WorkspaceUser } from './workspace-user.entity';

/**
 * Represents a workspace that contains members, goals, and standalone tasks.
 */
@Entity()
export class Workspace extends RootBaseEntity {
  @OneToMany(() => Goal, (goal) => goal.workspace)
  goals: Goal[];

  @OneToMany(() => WorkspaceUser, (wm) => wm.workspace)
  members: WorkspaceUser[];

  @Column()
  name: string;

  @OneToMany(() => Task, (t) => t.workspace)
  standaloneTasks: Task[];
}
