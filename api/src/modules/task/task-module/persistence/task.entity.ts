import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { Column, Entity, JoinColumn, ManyToOne, OneToMany } from 'typeorm';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { TaskAssignmentEntity } from '../../task-assignment/persistence/task-assignment.entity';

/**
 * Represents a concrete task that is abstracted via task assignments
 */
@Entity({ name: 'task' })
export class TaskEntity extends RootBaseEntity {
  @ManyToOne(() => WorkspaceEntity, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'workspace_id' })
  workspace!: WorkspaceEntity; // Workspace the task belongs to

  @Column({ type: 'varchar' })
  title!: string;

  @Column({ name: 'reward_points', type: 'smallint' })
  rewardPoints!: number;

  @Column({ nullable: true, type: 'varchar' })
  description!: string | null;

  @ManyToOne(() => WorkspaceUserEntity, { onDelete: 'SET NULL' })
  @JoinColumn({ name: 'created_by_id' })
  createdBy!: WorkspaceUserEntity | null;

  @Column({
    type: 'timestamptz',
    nullable: true,
    name: 'due_date',
  })
  dueDate!: string | null;

  @OneToMany(() => TaskAssignmentEntity, (ta) => ta.task)
  taskAssignments!: TaskAssignmentEntity[];
}
