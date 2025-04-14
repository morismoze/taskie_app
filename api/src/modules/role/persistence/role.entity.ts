import { Column, Entity, Index, JoinColumn, OneToMany } from 'typeorm';
import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { User } from 'src/modules/user/persistence/user.entity';
import { RoleEnum } from '../role.enum';

@Entity({
  name: 'role',
})
export class Role extends RootBaseEntity {
  @Column({
    type: 'enum',
    enum: RoleEnum,
    name: 'name',
  })
  @Index({
    unique: true,
  })
  name: string;

  @OneToMany(() => User, (user) => user.role)
  @JoinColumn({ referencedColumnName: 'id' })
  users: User[];
}
