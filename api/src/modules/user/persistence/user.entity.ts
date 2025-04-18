import { Column, Entity } from 'typeorm';
import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { UserStatus } from '../user-status.enum';
import { AuthProvider } from 'src/modules/auth/core/domain/auth-provider.enum';

/**
 * Represents a user in the system.
 * A user can exist in two forms:
 * 1. Registered via the app (either via auth provider or virtually by a Manager user).
 * 2. Virtual user created manually with just a name (e.g. children).
 */
@Entity({ name: 'user' })
export class UserEntity extends RootBaseEntity {
  @Column({ unique: true, length: 255, nullable: true })
  email: string | null; // Will be null for virtual users

  @Column({ length: 100 })
  firstName: string;

  @Column({ length: 100 })
  lastName: string;

  @Column({ nullable: true })
  profileImageUrl: string | null; // Will be null for virtual users

  @Column({
    type: 'enum',
    enum: AuthProvider,
  })
  provider: AuthProvider;

  @Column({ unique: true, nullable: true })
  socialId: string | null; // Will be null for virtual users

  @Column({
    type: 'enum',
    enum: UserStatus,
    default: UserStatus.ACTIVE,
  })
  status: UserStatus;
}
