import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { Column, Entity, Index, JoinColumn, ManyToOne } from 'typeorm';

@Entity({
  name: 'session',
})
export class SessionEntity extends RootBaseEntity {
  @ManyToOne(() => UserEntity, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  @Index()
  user!: UserEntity;

  @Column({ type: 'varchar' })
  hash!: string;

  @Column({ name: 'ip_address', type: 'varchar', length: 255 })
  ipAddress!: string;

  @Column({
    name: 'device_model',
    type: 'varchar',
    length: 255,
    nullable: true,
  })
  deviceModel!: string | null;

  @Column({ name: 'os_version', type: 'varchar', length: 255, nullable: true })
  osVersion!: string | null;

  @Column({ name: 'app_version', type: 'varchar', length: 255, nullable: true })
  appVersion!: string | null;

  @Column({
    name: 'build_number',
    type: 'varchar',
    length: 255,
    nullable: true,
  })
  buildNumber!: string | null;

  @Column({ name: 'access_token_version', type: 'int', default: 0 })
  accessTokenVersion!: number;
}
