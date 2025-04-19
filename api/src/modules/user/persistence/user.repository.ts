import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { Repository } from 'typeorm';
import { User } from '../domain/user.domain';
import { UserEntity } from './user.entity';

@Injectable()
export class UserRepository {
  constructor(
    @InjectRepository(UserEntity)
    private readonly repo: Repository<UserEntity>,
  ) {}

  async create(
    data: Omit<User, 'id' | 'createdAt' | 'deletedAt' | 'updatedAt'>,
  ): Promise<User> {
    const entity = this.repo.create(data);
    const newUser = await this.repo.save(entity);

    return this.toDomain(newUser);
  }

  async createVirtualUser(
    data: Pick<User, 'firstName' | 'lastName'>,
  ): Promise<User> {
    const entity = this.repo.create(data);
    const newUser = await this.repo.save(entity);

    return this.toDomain(newUser);
  }

  async findById(id: User['id']): Promise<Nullable<User>> {
    const user = await this.repo.findOne({ where: { id } });

    return user ? this.toDomain(user) : null;
  }

  async findByEmail(email: User['email']): Promise<Nullable<User>> {
    const user = await this.repo.findOne({ where: { email } });

    return user ? this.toDomain(user) : null;
  }

  async findBySocialIdAndProvider({
    socialId,
    provider,
  }: {
    socialId: User['socialId'];
    provider: User['provider'];
  }): Promise<Nullable<User>> {
    if (!socialId) return null;

    const user = await this.repo.findOne({
      where: {
        socialId,
        provider,
      },
    });

    if (!user) {
      return null;
    }

    return user ? this.toDomain(user) : null;
  }

  async update(data: User): Promise<Nullable<User>> {
    const entity = this.repo.create(data);
    await this.repo.save(entity);

    return await this.findById(data.id);
  }

  async softDelete(id: User['id']): Promise<void> {
    await this.repo.softDelete(id);
  }

  private toDomain(entity: UserEntity): User {
    return {
      id: entity.id,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      profileImageUrl: entity.profileImageUrl,
      provider: entity.provider,
      socialId: entity.socialId,
      status: entity.status,
    };
  }

  private toPersistence(user: User): UserEntity {
    const userEntity = new UserEntity();
    userEntity.id = user.id;
    userEntity.createdAt = user.createdAt;
    userEntity.updatedAt = user.updatedAt;
    userEntity.deletedAt = user.deletedAt;
    userEntity.email = user.email;
    userEntity.firstName = user.firstName;
    userEntity.lastName = user.lastName;
    userEntity.profileImageUrl = user.profileImageUrl;
    userEntity.provider = user.provider;
    userEntity.socialId = user.socialId;
    userEntity.status = user.status;

    return userEntity;
  }
}
