import {
  HttpStatus,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { ApiHttpException } from 'src/exception/ApiHttpException.model';
import { User } from './domain/user.domain';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { Nullable } from 'src/common/types/nullable.type';
import { UserStatus } from './domain/user-status.enum';
import { UserRepository } from './persistence/user.repository';

@Injectable()
export class UserService {
  constructor(private readonly userRepository: UserRepository) {}

  /**
   * This method creates a new user who "registered" via auth provider
   */
  async create(
    data: Omit<User, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>,
  ): Promise<User> {
    const existingUser = await this.userRepository.findByEmail(data.email);

    if (existingUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.EMAIL_ALREADY_EXISTS,
        },
        HttpStatus.UNPROCESSABLE_ENTITY,
      );
    }

    const newUser = await this.userRepository.create(data);

    if (!newUser) {
      throw new InternalServerErrorException();
    }

    return newUser;
  }

  /**
   * This method creates a new virtual user who was created by a Manager user
   */
  async createVirtualUser(data: {
    firstName: User['firstName'];
    lastName: User['lastName'];
  }): Promise<User> {
    const newVirtalUser = await this.userRepository.createVirtualUser(data);

    if (!newVirtalUser) {
      throw new InternalServerErrorException();
    }

    return newVirtalUser;
  }

  async findById(id: User['id']): Promise<Nullable<User>> {
    return this.userRepository.findById(id);
  }

  async findByEmail(email: User['email']): Promise<Nullable<User>> {
    return this.userRepository.findByEmail(email);
  }

  async findBySocialIdAndProvider({
    socialId,
    provider,
  }: {
    socialId: User['socialId'];
    provider: User['provider'];
  }): Promise<Nullable<User>> {
    return this.userRepository.findBySocialIdAndProvider({
      socialId,
      provider,
    });
  }

  /**
   * This method is used when a user updates itself
   * or when we update the user via the social login
   */
  async update(
    userId: User['id'],
    data: Partial<Omit<User, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>>,
  ): Promise<User> {
    const user = await this.userRepository.findById(userId);

    if (!user) {
      throw new NotFoundException();
    }

    // If email is present, check for email uniqueness
    if (data.email) {
      const existingUser = await this.userRepository.findByEmail(data.email);
      if (existingUser && existingUser.id !== userId) {
        throw new ApiHttpException(
          {
            code: ApiErrorCode.EMAIL_ALREADY_EXISTS,
          },
          HttpStatus.UNPROCESSABLE_ENTITY,
        );
      }
    }

    const updatedUser: User = {
      ...user,
      ...data,
    };

    const savedUpdatedUser = await this.userRepository.update(
      userId,
      updatedUser,
    );

    if (!savedUpdatedUser) {
      throw new InternalServerErrorException();
    }

    return savedUpdatedUser;
  }

  async softDelete(userId: User['id']): Promise<void> {
    const user = await this.userRepository.findById(userId);

    if (!user) {
      throw new NotFoundException();
    }

    await this.userRepository.softDelete(userId);

    await this.update(userId, { status: UserStatus.INACTIVE });
  }
}
