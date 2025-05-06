import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { Column, Entity, JoinColumn, ManyToOne, OneToMany } from 'typeorm';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { TaskAssignmentEntity } from '../../task-assignment/persistence/task-assignment.entity';

/**
 * Represents a concrete task that is abstracted via task assignments
 */
@Entity()
export class TaskEntity extends RootBaseEntity {
  @ManyToOne(() => WorkspaceEntity)
  @JoinColumn({ name: 'workspace_id' })
  workspace!: WorkspaceEntity; // Workspace the task belongs to

  @Column()
  title!: string;

  @Column({ name: 'reward_points' })
  rewardPoints!: number;

  @Column({ nullable: true })
  description!: string | null;

  @ManyToOne(() => UserEntity)
  @JoinColumn({ name: 'created_by_id' })
  createdBy!: WorkspaceUserEntity;

  @Column({ type: 'timestamp', nullable: true, name: 'due_date' })
  dueDate!: Date | null;

  @OneToMany(() => TaskAssignmentEntity, (ta) => ta.task)
  taskAssignments!: TaskAssignmentEntity[];
}
