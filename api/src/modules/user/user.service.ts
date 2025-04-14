import { HttpStatus, Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { Nullable } from '../../common/types/nullable.type';
import { v4 as uuidv4 } from 'uuid';
import * as bcrypt from 'bcryptjs';
import { User } from './persistence/user.entity';
import { RoleEnum } from '../role/role.enum';
import { StatusEnum } from '../status/status.enum';
import { RoleService } from '../role/role.service';
import { StatusService } from '../status/status.service';
import { UserRepository } from './persistence/user.repository';
import { FindManyOptions, FindOneOptions } from 'typeorm';
import { plainToInstance } from 'class-transformer';
import { UserDto } from './dto/user.dto';
import { ERROR_CODES } from 'src/exception/error-codes';
import { ApiHttpException } from 'src/exception/ApiHttpException.model';

@Injectable()
export class UserService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly roleService: RoleService,
    private readonly statusService: StatusService,
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

  async findOne(fields: FindOneOptions<User>): Promise<Nullable<User>> {
    return this.userRepository.findOne(fields);
  }

  async findAll(fields?: FindManyOptions<User>): Promise<UserDto[]> {
    const users = await this.userRepository.find(fields);

    return plainToInstance(UserDto, users);
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
