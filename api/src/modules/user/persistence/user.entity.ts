import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Role } from '../../role/persistence/role.entity';
import { Status } from '../../status/persistence/status.entity';
import { Exclude } from 'class-transformer';
import { RootBaseEntity } from 'src/common/entity/root-base.entity';

@Entity({
  name: 'user',
})
export class User extends RootBaseEntity {
  @Index()
  @Column({ unique: true, length: 255 })
  email: string;

  @Column({ length: 100 })
  @Exclude({ toPlainOnly: true })
  password: string;

  @Index()
  @Column({ unique: true })
  username: string;

  @ManyToOne(() => Role, (role) => role.users, {
    eager: true,
  })
  @JoinColumn({ name: 'role_id', referencedColumnName: 'id' })
  role: Role;

  @ManyToOne(() => Status, (status) => status.users, {
    eager: true,
  })
  @JoinColumn({ name: 'status_id', referencedColumnName: 'id' })
  status: Status;
}
