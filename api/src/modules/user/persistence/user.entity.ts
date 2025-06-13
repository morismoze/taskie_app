import { Column, Entity } from 'typeorm';
import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { UserStatus } from '../domain/user-status.enum';
import { AuthProvider } from 'src/modules/auth/core/domain/auth-provider.enum';

/**
 * Represents a user in the system.
 * A user can exist in two forms:
 * 1. Registered via the app (either via auth provider or virtually by a Manager user).
 * 2. Virtual user created manually with just a name (e.g. children).
 */
@Entity({ name: 'user' })
export class UserEntity extends RootBaseEntity {
  @Column({ unique: true, type: 'varchar', nullable: true })
  email!: string | null; // Will be null for virtual users

  @Column({ name: 'first_name', type: 'varchar' })
  firstName!: string;

  @Column({ name: 'last_name', type: 'varchar' })
  lastName!: string;

  @Column({ name: 'profile_image_url', type: 'varchar', nullable: true })
  profileImageUrl!: string | null; // Will be null for virtual users

  @Column({
    type: 'enum',
    enum: AuthProvider,
    nullable: true,
  })
  provider!: AuthProvider | null;

  @Column({ name: 'social_id', unique: true, type: 'varchar', nullable: true })
  socialId!: string | null; // Will be null for virtual users

  @Column({
    type: 'enum',
    enum: UserStatus,
  })
  status!: UserStatus;
}
