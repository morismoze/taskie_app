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

  @Column({ name: 'ip_address', type: 'varchar', length: 255 })
  ipAddress: string;

  @Column({ name: 'device_id', type: 'varchar', length: 255, nullable: true })
  deviceId: string | null;

  @Column({
    name: 'device_model',
    type: 'varchar',
    length: 255,
    nullable: true,
  })
  deviceModel: string | null;

  @Column({ name: 'os_version', type: 'varchar', length: 255, nullable: true })
  osVersion: string | null;

  @Column({ name: 'app_version', type: 'varchar', length: 255, nullable: true })
  appVersion: string | null;
}
