import { Nullable } from 'src/common/types/nullable.type';
import { User } from '../domain/user.domain';
import { UserEntity } from './user.entity';

export abstract class UserRepository {
  abstract create(data: {
    email: NonNullable<User['email']>;
    firstName: User['firstName'];
    lastName: User['lastName'];
    socialId: NonNullable<User['socialId']>;
    provider: NonNullable<User['provider']>;
    profileImageUrl: User['profileImageUrl'];
    status: User['status'];
  }): Promise<Nullable<UserEntity>>;

  abstract createVirtualUser(
    data: Pick<User, 'firstName' | 'lastName' | 'status'>,
  ): Promise<Nullable<UserEntity>>;

  abstract findById(id: User['id']): Promise<Nullable<UserEntity>>;

  abstract findByEmail(
    email: NonNullable<User['email']>,
  ): Promise<Nullable<UserEntity>>;

  abstract findBySocialIdAndProvider(args: {
    socialId: NonNullable<User['socialId']>;
    provider: NonNullable<User['provider']>;
  }): Promise<Nullable<UserEntity>>;

  abstract update(args: {
    id: User['id'];
    data: Partial<Omit<User, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>>;
  }): Promise<Nullable<UserEntity>>;

  abstract delete(id: User['id']): Promise<boolean>;
}
