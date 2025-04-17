import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { Task } from 'src/modules/task/task-module/persistence/task.entity';
import { User } from 'src/modules/user/persistence/user.entity';
import { Column, Entity, ManyToOne } from 'typeorm';

/**
 * This entity is an abstraction of a user assigned to a task, which:
 * 1. Might be tied to a real User account
 * 2. Might not be a User, just a name
 *
 * This offers us the ability to e.g. know when the user
 * was assigned that task (createdAt)
 */

@Entity()
export class TaskAssignee extends RootBaseEntity {
  // Used when user is a registered person
  @ManyToOne(() => User)
  user: User;

  // Used when user is null (non-registered person)
  @Column({ nullable: true })
  firstName: string | null;

  // Used when user is null (non-registered person)
  @Column({ nullable: true })
  lastName: string | null;

  @ManyToOne(() => Task, (task) => task.assignees, { onDelete: 'CASCADE' })
  task: Task;
}
