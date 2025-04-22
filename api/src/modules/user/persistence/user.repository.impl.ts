import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { Repository } from 'typeorm';
import { User } from '../domain/user.domain';
import { UserEntity } from './user.entity';
import { UserMapper } from './user.mapper';
import { UserRepository } from './user.repository';

@Injectable()
export class UserRepositoryImpl implements UserRepository {
  constructor(
    @InjectRepository(UserEntity)
    private readonly repo: Repository<UserEntity>,
  ) {}

  async create(data: User): Promise<Nullable<User>> {
    const persistenceModel = UserMapper.toPersistence(data);

    // No need to re-query the saved entity since UserEntity
    // doesn't have any foreign entity relations, so no need to
    // load any foreign entities
    const newEntity = await this.repo.save(persistenceModel);

    return newEntity !== null ? UserMapper.toDomain(newEntity) : null;
  }

  async createVirtualUser(data: User): Promise<Nullable<User>> {
    const persistenceModel = UserMapper.toPersistence(data);

    const newEntity = await this.repo.save(persistenceModel);

    return newEntity !== null ? UserMapper.toDomain(newEntity) : null;
  }

  async findById(id: User['id']): Promise<Nullable<User>> {
    const user = await this.repo.findOne({ where: { id } });

    return user ? UserMapper.toDomain(user) : null;
  }

  async findByEmail(
    email: NonNullable<User['email']>,
  ): Promise<Nullable<User>> {
    const user = await this.repo.findOne({ where: { email } });

    return user ? UserMapper.toDomain(user) : null;
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

    return user ? UserMapper.toDomain(user) : null;
  }

  async update(id: User['id'], data: User): Promise<Nullable<User>> {
    const persistenceModel = UserMapper.toPersistence(data);

    await this.repo.save(persistenceModel);

    return this.findById(id);
  }

  async softDelete(id: User['id']): Promise<void> {
    await this.repo.softDelete(id);
  }
}
