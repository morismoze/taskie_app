import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { Column, Entity, JoinColumn, ManyToOne, Unique } from 'typeorm';
import { ProgressStatus } from '../../task-module/domain/progress-status.enum';
import { TaskEntity } from '../../task-module/persistence/task.entity';

/**
 * Single task can be assigned to multiple users, and one user can have multiple
 * tasks assigned, so a single task can have multiple statuses depending on the
 * assignee. This entity can also be used to store additional details like date deadline etc.
 *
 * The TaskEntity is just a template or definition — a "what to do".
 * The TaskAssignmentEntity is the personalized copy of the task, tied to a user and possibly to a goal.
 */

@Entity({ name: 'task_assignment' })
@Unique('UQ_task_assignment', ['task', 'assignee'])
export class TaskAssignmentEntity extends RootBaseEntity {
  @ManyToOne(() => TaskEntity, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'task_id' })
  task!: TaskEntity;

  @ManyToOne(() => WorkspaceUserEntity, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'assignee_id' })
  assignee!: WorkspaceUserEntity;

  @Column({
    type: 'enum',
    enum: ProgressStatus,
    default: ProgressStatus.IN_PROGRESS,
  })
  status!: ProgressStatus;
}
