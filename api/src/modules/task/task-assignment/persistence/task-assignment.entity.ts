import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { Column, Entity, JoinColumn, ManyToOne } from 'typeorm';
import { ProgressStatus } from '../../task-module/domain/progress-status.enum';
import { TaskEntity } from '../../task-module/persistence/task.entity';

/**
 * Single task can be assigned to multiple users, and one user can have multiple
 * tasks assigned, so a single task can have multiple statuses depending on the
 * assignee. This entity can also be used to store additional details like date deadline etc.
 */

@Entity()
export class TaskAssignmentEntity extends RootBaseEntity {
  @ManyToOne(() => TaskEntity, (task) => task.taskAssignments)
  @JoinColumn({ name: 'task_id' })
  task: TaskEntity;

  @ManyToOne(() => WorkspaceUserEntity, (assignee) => assignee.taskAssignments)
  @JoinColumn({ name: 'assignee_id' })
  assignee: WorkspaceUserEntity;

  @Column({
    type: 'enum',
    enum: ProgressStatus,
    default: ProgressStatus.IN_PROGRESS,
  })
  status: ProgressStatus;
}
