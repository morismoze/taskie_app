import { Nullable } from 'src/common/types/nullable.type';
import { User } from '../domain/user.domain';

export abstract class UserRepository {
  abstract create(
    data: Omit<User, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>,
  ): Promise<Nullable<User>>;

  abstract createVirtualUser(
    data: Pick<User, 'firstName' | 'lastName'>,
  ): Promise<Nullable<User>>;

  abstract findById(id: User['id']): Promise<Nullable<User>>;

  abstract findByEmail(email: User['email']): Promise<Nullable<User>>;

  abstract findBySocialIdAndProvider(input: {
    socialId: User['socialId'];
    provider: User['provider'];
  }): Promise<Nullable<User>>;

  abstract update(id: User['id'], data: User): Promise<Nullable<User>>;

  abstract softDelete(id: User['id']): Promise<void>;
}
