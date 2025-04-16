import { Column, Entity, JoinColumn, ManyToOne } from 'typeorm';
import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { UserStatusEnum } from '../user-status.enum';

/**
 * Represents a user in the system.
 * A user can exist in two forms:
 * 1. Registered via the app (Google Auth).
 * 2. Virtual user created manually with just a name (e.g. children).
 */
@Entity({ name: 'user' })
export class User extends RootBaseEntity {
  @Column({ unique: true, length: 255, nullable: true })
  email: string | null; // will be null for virtual users

  @Column({ length: 100 })
  firstName: string;

  @Column({ length: 100 })
  lastName: string;

  @Column({ nullable: true })
  profileImageUrl: string | null; // will be null for virtual users

  @Column({ unique: true, nullable: true })
  socialId: string | null; // will be null for virtual users

  @Column({
    type: 'enum',
    enum: UserStatusEnum,
    default: UserStatusEnum.ACTIVE,
  })
  status: UserStatusEnum;
}
