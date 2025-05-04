import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { GoalEntity } from 'src/modules/goal/persistence/goal.entity';
import { TaskEntity } from 'src/modules/task/task-module/persistence/task.entity';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { Column, Entity, JoinColumn, ManyToOne, OneToMany } from 'typeorm';
import { WorkspaceUserEntity } from '../../workspace-user-module/persistence/workspace-user.entity';

/**
 * Represents a workspace that contains members, goals, and standalone tasks.
 */
@Entity()
export class WorkspaceEntity extends RootBaseEntity {
  @ManyToOne(() => UserEntity)
  @JoinColumn({ name: 'owned_by_id' })
  createdBy: UserEntity;

  @OneToMany(() => GoalEntity, (goal) => goal.workspace)
  goals: GoalEntity[];

  @OneToMany(() => WorkspaceUserEntity, (wm) => wm.workspace)
  members: WorkspaceUserEntity[];

  @Column()
  name: string;

  @Column({ nullable: true })
  description: string | null;

  @OneToMany(() => TaskEntity, (t) => t.workspace)
  tasks: TaskEntity[];

  @Column({ name: 'picture_url', nullable: true })
  pictureUrl: string | null;
}
