import { Column, Entity, Index, JoinColumn, ManyToOne } from 'typeorm';
import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { UserStatus } from '../../user-status-module/persistence/user-status.entity';

@Entity({
  name: 'user',
})
export class User extends RootBaseEntity {
  @Index()
  @Column({ unique: true, length: 255 })
  email: string;

  @Column({ length: 100 })
  firstName: string;

  @Column({ length: 100 })
  lastName: string;

  @Column({ nullable: true, unique: true })
  socialId: string | null;

  @Column({ nullable: true })
  profileImageUrl: string | null;

  @ManyToOne(() => UserStatus, (status) => status.users, {
    eager: true,
  })
  @JoinColumn({ name: 'status_id', referencedColumnName: 'id' })
  status: UserStatus;
}
