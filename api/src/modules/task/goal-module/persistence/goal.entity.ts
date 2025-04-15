import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { Task } from 'src/modules/task/task-module/persistence/task.entity';
import { WorkspaceMember } from 'src/modules/workspace/workspace-module/persistence/workspace-member.entity';
import { Column, Entity, JoinTable, ManyToMany, ManyToOne } from 'typeorm';
import { GoalStatus } from '../goal-status.enum';

@Entity()
export class Goal extends RootBaseEntity {
  @Column()
  name: string;

  @Column({ nullable: true })
  description: string | null;

  @Column({ type: 'enum', enum: GoalStatus, default: GoalStatus.IN_PROGRESS })
  status: GoalStatus;

  @Column({ nullable: true })
  reward: string; // The reward for completing the goal, once all tasks are done

  @ManyToOne(() => WorkspaceMember)
  owner: WorkspaceMember;

  @ManyToMany(() => Task)
  @JoinTable()
  tasks: Task[]; // Tasks that count toward this goal
}
