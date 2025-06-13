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

  async create(data: {
    email: NonNullable<User['email']>;
    firstName: User['firstName'];
    lastName: User['lastName'];
    socialId: NonNullable<User['socialId']>;
    provider: NonNullable<User['provider']>;
    profileImageUrl: User['profileImageUrl'];
    status: User['status'];
  }): Promise<Nullable<UserEntity>> {
    const persistenceModel = this.repo.create({
      email: data.email,
      firstName: data.firstName,
      lastName: data.lastName,
      profileImageUrl: data.profileImageUrl,
      provider: data.provider,
      socialId: data.socialId,
      status: data.status,
    });

    const savedEntity = await this.transactionalUserRepo.save(persistenceModel);

    const newEntity = await this.transactionalUserRepo.findOne({
      where: { id: savedEntity.id },
    });

    return newEntity;
  }

  async createVirtualUser(
    data: Pick<User, 'firstName' | 'lastName' | 'status'>,
  ): Promise<Nullable<UserEntity>> {
    const persistenceModel = this.repo.create({
      firstName: data.firstName,
      lastName: data.lastName,
      status: data.status,
    });

    const savedEntity = await this.transactionalUserRepo.save(persistenceModel);

    const newEntity = await this.transactionalUserRepo.findOne({
      where: { id: savedEntity.id },
    });

    return newEntity;
  }

  async findById(id: User['id']): Promise<Nullable<UserEntity>> {
    return await this.repo.findOne({
      where: { id },
    });
  }

  async findByEmail(
    email: NonNullable<User['email']>,
  ): Promise<Nullable<UserEntity>> {
    return await this.repo.findOne({
      where: { email },
    });
  }

  async findBySocialIdAndProvider({
    socialId,
    provider,
  }: {
    socialId: NonNullable<User['socialId']>;
    provider: NonNullable<User['provider']>;
  }): Promise<Nullable<UserEntity>> {
    return await this.repo.findOne({
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
    await this.transactionalUserRepo.update(id, data);

    const updatedEntity = await this.transactionalUserRepo.findOne({
      where: { id },
    });

    return updatedEntity;
  }

  async delete(id: User['id']): Promise<void> {
    await this.repo.delete(id);
  }

  private get transactionalUserRepo(): Repository<UserEntity> {
    return this.transactionalRepository.getRepository(UserEntity);
  }
}
