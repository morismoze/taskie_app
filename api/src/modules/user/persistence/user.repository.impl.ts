import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { TransactionalRepository } from 'src/modules/unit-of-work/persistence/transactional.repository';
import { Repository } from 'typeorm';
import { User } from '../domain/user.domain';
import { UserEntity } from './user.entity';
import { UserRepository } from './user.repository';

@Injectable()
export class UserRepositoryImpl implements UserRepository {
  constructor(
    @InjectRepository(UserEntity)
    private readonly repo: Repository<UserEntity>,
    private readonly transactionalRepository: TransactionalRepository,
  ) {}

  private get repositoryContext(): Repository<UserEntity> {
    const transactional =
      this.transactionalRepository.getRepository(UserEntity);

    // If there is a transactional repo available (a transaction bound to the
    // request is available), use it. Otherwise, use normal repo.
    return transactional || this.repo;
  }

  async create(data: {
    email: NonNullable<User['email']>;
    firstName: User['firstName'];
    lastName: User['lastName'];
    socialId: NonNullable<User['socialId']>;
    provider: NonNullable<User['provider']>;
    profileImageUrl: User['profileImageUrl'];
    status: User['status'];
  }): Promise<Nullable<UserEntity>> {
    const persistenceModel = this.repositoryContext.create({
      email: data.email,
      firstName: data.firstName,
      lastName: data.lastName,
      profileImageUrl: data.profileImageUrl,
      provider: data.provider,
      socialId: data.socialId,
      status: data.status,
    });

    const savedEntity = await this.repositoryContext.save(persistenceModel);

    const newEntity = await this.repositoryContext.findOne({
      where: { id: savedEntity.id },
    });

    return newEntity;
  }

  async createVirtualUser(
    data: Pick<User, 'firstName' | 'lastName' | 'status'>,
  ): Promise<Nullable<UserEntity>> {
    const persistenceModel = this.repositoryContext.create({
      firstName: data.firstName,
      lastName: data.lastName,
      status: data.status,
    });

    const savedEntity = await this.repositoryContext.save(persistenceModel);

    const newEntity = await this.repositoryContext.findOne({
      where: { id: savedEntity.id },
    });

    return newEntity;
  }

  findById(id: User['id']): Promise<Nullable<UserEntity>> {
    return this.repositoryContext.findOne({
      where: { id },
    });
  }

  findByEmail(
    email: NonNullable<User['email']>,
  ): Promise<Nullable<UserEntity>> {
    return this.repositoryContext.findOne({
      where: { email },
    });
  }

  findBySocialIdAndProvider({
    socialId,
    provider,
  }: {
    socialId: NonNullable<User['socialId']>;
    provider: NonNullable<User['provider']>;
  }): Promise<Nullable<UserEntity>> {
    return this.repositoryContext.findOne({
      where: {
        socialId,
        provider,
      },
    });
  }

  async update({
    id,
    data,
  }: {
    id: User['id'];
    data: Partial<Omit<User, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>>;
  }): Promise<Nullable<UserEntity>> {
    const result = await this.repositoryContext.update(id, data);

    // Early return - provided ID does not exist
    if (result.affected === 0) {
      return null;
    }

    const updatedEntity = await this.repositoryContext.findOne({
      where: { id },
    });

    return updatedEntity;
  }

  async delete(id: User['id']): Promise<boolean> {
    const result = await this.repositoryContext.delete(id);
    return (result.affected ?? 0) > 0;
  }
}
