import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { GoalEntity } from 'src/modules/goal/persistence/goal.entity';
import { TaskEntity } from 'src/modules/task/task-module/persistence/task.entity';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { Column, Entity, JoinColumn, ManyToOne, OneToMany } from 'typeorm';
import { WorkspaceUserEntity } from '../../workspace-user-module/persistence/workspace-user.entity';

/**
 * Represents a workspace that contains members, goals, and standalone tasks.
 * `createdBy` can be null in the case owner deleted account and the workspace
 * doesn't have any more Manager users.
 */
@Entity({ name: 'workspace' })
export class WorkspaceEntity extends RootBaseEntity {
  @ManyToOne(() => UserEntity, { onDelete: 'SET NULL', nullable: true })
  @JoinColumn({ name: 'owned_by_id' })
  createdBy!: UserEntity | null;

  @OneToMany(() => GoalEntity, (goal) => goal.workspace)
  goals!: GoalEntity[];

  @OneToMany(() => WorkspaceUserEntity, (wu) => wu.workspace)
  members!: WorkspaceUserEntity[];

  @Column({ type: 'varchar' })
  name!: string;

  @Column({ nullable: true, type: 'varchar' })
  description!: string | null;

  @OneToMany(() => TaskEntity, (t) => t.workspace)
  tasks!: TaskEntity[];

  @Column({ name: 'picture_url', type: 'varchar', nullable: true })
  pictureUrl!: string | null;
}
