import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { AuthProvider } from 'src/modules/auth/core/domain/auth-provider.enum';
import { UserStatus } from 'src/modules/user/domain/user-status.enum';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { Repository } from 'typeorm';

@Injectable()
export class UserSeedService {
  constructor(
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
  ) {}

  async run() {
    const countUser1 = await this.userRepository.count({
      where: {
        email: 'john.doe@example.com',
      },
    });

    if (countUser1 === 0) {
      const user1 = await this.userRepository.save(
        this.userRepository.create({
          email: 'john.doe@example.com',
          firstName: 'John',
          lastName: 'Doe',
          status: UserStatus.ACTIVE,
          provider: AuthProvider.GOOGLE,
          socialId: 'google-john',
        }),
      );
    }

    const countUser2 = await this.userRepository.count({
      where: {
        email: 'jane.smith@example.com',
      },
    });

    if (countUser2 === 0) {
      const user2 = await this.userRepository.save(
        this.userRepository.create({
          email: 'jane.smith@example.com',
          firstName: 'Jane',
          lastName: 'Smith',
          status: UserStatus.ACTIVE,
          provider: AuthProvider.GOOGLE,
          socialId: 'google-jane',
        }),
      );
    }
  }
}
