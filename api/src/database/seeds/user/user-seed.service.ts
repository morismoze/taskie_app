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
      await this.userRepository.save(
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
      await this.userRepository.save(
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

    const countUser3 = await this.userRepository.count({
      where: {
        firstName: 'Peter',
        lastName: 'Griffin',
      },
    });

    if (countUser3 === 0) {
      await this.userRepository.save(
        this.userRepository.create({
          email: null,
          firstName: 'Peter',
          lastName: 'Griffin',
          status: UserStatus.ACTIVE,
          provider: null,
          socialId: null,
        }),
      );
    }

    const countUser4 = await this.userRepository.count({
      where: {
        firstName: 'Jim',
        lastName: 'Morrison',
      },
    });

    if (countUser4 === 0) {
      await this.userRepository.save(
        this.userRepository.create({
          email: null,
          firstName: 'Jim',
          lastName: 'Morrison',
          status: UserStatus.ACTIVE,
          provider: null,
          socialId: null,
        }),
      );
    }

    const countUser5 = await this.userRepository.count({
      where: {
        firstName: 'Diego',
        lastName: 'Maradona',
      },
    });

    if (countUser5 === 0) {
      await this.userRepository.save(
        this.userRepository.create({
          email: null,
          firstName: 'Diego',
          lastName: 'Maradona',
          status: UserStatus.ACTIVE,
          provider: null,
          socialId: null,
        }),
      );
    }

    const countUser6 = await this.userRepository.count({
      where: {
        firstName: 'Andrej',
        lastName: 'Plenković',
      },
    });

    if (countUser6 === 0) {
      await this.userRepository.save(
        this.userRepository.create({
          email: null,
          firstName: 'Andrej',
          lastName: 'Plenković',
          status: UserStatus.ACTIVE,
          provider: null,
          socialId: null,
        }),
      );
    }
  }
}
