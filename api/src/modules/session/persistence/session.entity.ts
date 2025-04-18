import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { User } from 'src/modules/user/persistence/user.entity';
import { Column, Entity, Index, ManyToOne } from 'typeorm';

@Entity({
  name: 'session',
})
export class Session extends RootBaseEntity {
  @ManyToOne(() => User, {
    eager: true,
  })
  @Index()
  user: User;

  @Column()
  hash: string;
}
