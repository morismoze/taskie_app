import { HttpStatus, Injectable } from '@nestjs/common';
import { ApiHttpException } from 'src/exception/ApiHttpException.type';
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
  async create(data: {
    email: NonNullable<User['email']>;
    firstName: User['firstName'];
    lastName: User['lastName'];
    socialId: NonNullable<User['socialId']>;
    provider: NonNullable<User['provider']>;
    profileImageUrl: User['profileImageUrl'];
    status: User['status'];
  }): Promise<User> {
    const existingUser = await this.userRepository.findByEmail(data.email!);

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
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return newUser;
  }

  /**
   * This method creates a new virtual user who was created by a Manager user
   */
  async createVirtualUser(
    data: Pick<User, 'firstName' | 'lastName' | 'status'>,
  ): Promise<User> {
    const newVirtalUser = await this.userRepository.createVirtualUser(data);

    if (!newVirtalUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return newVirtalUser;
  }

  async findById(id: User['id']): Promise<Nullable<User>> {
    return this.userRepository.findById(id);
  }

  async findByEmail(
    email: NonNullable<User['email']>,
  ): Promise<Nullable<User>> {
    return this.userRepository.findByEmail(email);
  }

  async findBySocialIdAndProvider({
    socialId,
    provider,
  }: {
    socialId: NonNullable<User['socialId']>;
    provider: NonNullable<User['provider']>;
  }): Promise<Nullable<User>> {
    return this.userRepository.findBySocialIdAndProvider({
      socialId,
      provider,
    });
  }

  async update({
    id,
    data,
  }: {
    id: User['id'];
    data: Partial<Omit<User, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>>;
  }): Promise<User> {
    const user = await this.userRepository.findById(id);

    if (!user) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    // If email is present, check for email uniqueness
    if (data.email) {
      const existingUser = await this.userRepository.findByEmail(data.email);

      if (existingUser && existingUser.id !== id) {
        throw new ApiHttpException(
          {
            code: ApiErrorCode.EMAIL_ALREADY_EXISTS,
          },
          HttpStatus.CONFLICT,
        );
      }
    }

    const updatedUser = await this.userRepository.update({
      id,
      data,
    });

    if (!updatedUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return updatedUser;
  }

  async delete(userId: User['id']): Promise<void> {
    await this.userRepository.delete(userId);
  }
}
