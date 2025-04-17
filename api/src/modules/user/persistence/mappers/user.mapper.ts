import { Injectable } from '@nestjs/common';
import { UserDomain } from '../../domain/user.domain';
import { User } from '../user.entity';

@Injectable()
export class UserMapper {
  toDomain(user: User): UserDomain {
    return {
      id: user.id,
      createdAt: user.createdAt,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      profileImageUrl: user.profileImageUrl,
      socialId: user.socialId,
      provider: user.provider,
      status: user.status,
    };
  }
}
