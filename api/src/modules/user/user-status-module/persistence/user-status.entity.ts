import { Column, Entity, Index, OneToMany } from 'typeorm';
import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { UserStatusEnum } from '../user-status.enum';
import { User } from '../../user-module/persistence/user.entity';

@Entity({
  name: 'status',
})
export class UserStatus extends RootBaseEntity {
  @Column({
    type: 'enum',
    enum: UserStatusEnum,
    default: UserStatusEnum.ACTIVE,
  })
  @Index({
    unique: true,
  })
  name: string;

  @OneToMany(() => User, (user) => user.status)
  users: User[];
}
