import { HttpStatus, Injectable } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import * as bcrypt from 'bcryptjs';
import { User } from './persistence/user.entity';
import { UserDto } from './dto/user.dto';
import { ApiHttpException } from 'src/exception/ApiHttpException.model';
import { UserDomain } from './domain/user.domain';
import { UserRepository } from './persistence/user.repository';
import { UserMapper } from './persistence/mappers/user.mapper';
import { UserUpdateRequest } from './dto/user-update.dto';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { Nullable } from 'src/common/types/nullable.type';

@Injectable()
export class UserService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly userMapper: UserMapper,
  ) {}

  async create(createUserDto: CreateUserDto): Promise<User> {
    const user = await this.userRepository.findOne({
      where: {
        email: createUserDto.email,
      },
    });

    if (user) {
      throw new ApiHttpException(
        {
          field: 'email',
          message: ERROR_CODES.EXISTING_USER.message,
        },
        HttpStatus.UNPROCESSABLE_ENTITY,
      );
    }

    const newUser = new User();
    newUser.uid = uuidv4();
    newUser.email = createUserDto.email;
    newUser.firstName = createUserDto.firstName;
    newUser.lastName = createUserDto.lastName;
    const salt = await bcrypt.genSalt();
    newUser.password = await bcrypt.hash(createUserDto.password, salt);
    const role = await this.roleService.findOne({
      where: {
        name: createUserDto.role ? createUserDto.role.name : RoleEnum.user,
      },
    });
    newUser.role = role!;
    const status = await this.statusService.findOne({
      where: {
        name: createUserDto.status
          ? createUserDto.status.name
          : StatusEnum.active,
      },
    });
    newUser.status = status!;

    return this.userRepository.save(this.userRepository.create(newUser));
  }

  async findById(id: UserDomain['id']): Promise<Nullable<User>> {
    return this.userRepository.findById(id);
  }

  async findByEmail(email: UserDomain['email']): Promise<Nullable<User>> {
    return this.userRepository.findByEmail(email);
  }

  async findBySocialIdAndProvider({
    socialId,
    provider,
  }: {
    socialId: UserDomain['socialId'];
    provider: UserDomain['provider'];
  }): Promise<Nullable<User>> {
    return this.userRepository.findBySocialIdAndProvider({
      socialId,
      provider,
    });
  }

  async updateSelf(
    userId: UserDomain['id'],
    updateUserRequest: UserUpdateRequest,
  ): Promise<UserDomain | null> {
    // If email is present, check for uniqueness
    if (updateUserRequest.email) {
      const existingUser = await this.userRepository.findByEmail(
        updateUserRequest.email,
      );
      if (existingUser && existingUser.id !== userId) {
        throw new ApiHttpException(
          {
            code: ApiErrorCode.INVALID_PAYLOAD,
          },
          HttpStatus.UNPROCESSABLE_ENTITY,
        );
      }
    }

    const updatedUser = await this.userRepository.update(
      userId,
      updateUserRequest,
    );

    if (!updatedUser) {
      throw new ApiHttpException(
        { code: ApiErrorCode.USER_NOT_FOUND },
        HttpStatus.NOT_FOUND,
      );
    }

    return this.userMapper.toDomain(updatedUser);
  }

  async softDelete(uid: UserDto['uid']): Promise<void> {
    const user = await this.userRepository.findOne({
      where: {
        uid,
      },
    });

    if (!user) {
      throw new ApiHttpException(
        {
          field: 'uid',
          message: ERROR_CODES.NON_EXISTING_USER.message,
        },
        HttpStatus.UNPROCESSABLE_ENTITY,
      );
    }

    await this.userRepository.softDelete(uid);
    const inactiveStatus = await this.statusService.findOne({
      where: { name: StatusEnum.inactive },
    });
    await this.userRepository.update({ uid }, { status: inactiveStatus! });
  }
}
