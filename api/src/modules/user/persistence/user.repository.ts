import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { Repository } from 'typeorm';
import { UserDomain } from '../domain/user.domain';
import { UserUpdateRequest } from '../dto/user-update.dto';
import { User } from './user.entity';

@Injectable()
export class UserRepository {
  constructor(
    @InjectRepository(User)
    private readonly repo: Repository<User>,
  ) {}

  async findById(id: UserDomain['id']): Promise<Nullable<User>> {
    return await this.repo.findOne({ where: { id } });
  }

  async findByEmail(email: UserDomain['email']): Promise<Nullable<User>> {
    return await this.repo.findOne({ where: { email } });
  }

  async findBySocialIdAndProvider({
    socialId,
    provider,
  }: {
    socialId: UserDomain['socialId'];
    provider: UserDomain['provider'];
  }): Promise<Nullable<User>> {
    if (!socialId) return null;

    return await this.repo.findOne({
      where: {
        socialId,
        provider,
      },
    });
  }

  async update(
    id: UserDomain['id'],
    updateUserDto: UserUpdateRequest,
  ): Promise<Nullable<User>> {
    const user = await this.repo.findOne({ where: { id } });

    if (!user) {
      return null;
    }

    if (updateUserDto.email !== undefined) {
      user.email = updateUserDto.email;
    }

    if (updateUserDto.firstName !== undefined) {
      user.firstName = updateUserDto.firstName;
    }

    if (updateUserDto.lastName !== undefined) {
      user.lastName = updateUserDto.lastName;
    }

    if (updateUserDto.profileImageUrl !== undefined) {
      user.profileImageUrl = updateUserDto.profileImageUrl;
    }

    if (updateUserDto.status !== undefined) {
      user.status = updateUserDto.status;
    }

    return await this.repo.save(user);
  }
}
