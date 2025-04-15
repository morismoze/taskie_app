import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { Task } from 'src/modules/task/task-module/persistence/task.entity';
import { Column, Entity, OneToMany } from 'typeorm';
import { WorkspaceMember } from './workspace-member.entity';

@Entity()
export class Workspace extends RootBaseEntity {
  @Column()
  name: string;

  @OneToMany(() => WorkspaceMember, (wm) => wm.workspace)
  members: WorkspaceMember[];

  @OneToMany(() => Task, (t) => t.workspace)
  standaloneTasks: Task[];
}
