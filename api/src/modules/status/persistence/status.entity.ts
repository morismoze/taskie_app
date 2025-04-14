import { Column, Entity, Index, JoinColumn, OneToMany } from 'typeorm';
import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { User } from 'src/modules/user/persistence/user.entity';
import { StatusEnum } from '../status.enum';

@Entity({
  name: 'status',
})
export class Status extends RootBaseEntity {
  @Column({
    type: 'enum',
    enum: StatusEnum,
    name: 'name',
  })
  @Index({
    unique: true,
  })
  name: string;

  @OneToMany(() => User, (user) => user.status)
  @JoinColumn({ referencedColumnName: 'id' })
  users: User[];
}
