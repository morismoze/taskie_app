import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { Column, Entity, Index, ManyToOne } from 'typeorm';

@Entity({
  name: 'session',
})
export class SessionEntity extends RootBaseEntity {
  @ManyToOne(() => UserEntity, {
    eager: true,
  })
  @Index()
  user: UserEntity;

  @Column()
  hash: string;
}
