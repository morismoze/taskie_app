import { User } from '../domain/user.domain';
import { UserEntity } from './user.entity';

export class UserMapper {
  static toDomain(entity: UserEntity): User {
    const domain = new User();

    domain.id = entity.id;
    domain.email = entity.email;
    domain.firstName = entity.firstName;
    domain.lastName = entity.lastName;
    domain.profileImageUrl = entity.profileImageUrl;
    domain.provider = entity.provider;
    domain.socialId = entity.socialId;
    domain.status = entity.status;
    domain.createdAt = entity.createdAt;
    domain.updatedAt = entity.updatedAt;
    domain.deletedAt = entity.deletedAt;

    return domain;
  }

  static toPersistence(domain: User): UserEntity {
    const entity = new UserEntity();

    entity.id = domain.id;
    entity.email = domain.email;
    entity.firstName = domain.firstName;
    entity.lastName = domain.lastName;
    entity.profileImageUrl = domain.profileImageUrl;
    entity.provider = domain.provider;
    entity.socialId = domain.socialId;
    entity.status = domain.status;
    entity.createdAt = domain.createdAt;
    entity.updatedAt = domain.updatedAt;
    entity.deletedAt = domain.deletedAt;

    return entity;
  }
}
