import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { User } from 'src/modules/user/domain/user.domain';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { Repository } from 'typeorm';
import { Session } from '../domain/session.domain';
import { SessionEntity } from './session.entity';

@Injectable()
export class SessionRepository {
  constructor(
    @InjectRepository(SessionEntity)
    private readonly repo: Repository<SessionEntity>,
  ) {}

  async create(
    userId: Session['user']['id'],
    hash: Session['hash'],
  ): Promise<Session> {
    const entity = this.repo.create({
      hash: hash,
      user: { id: userId }, // TypeORM supports setting relations by reference
    });

    const newSession = await this.repo.save(entity);

    return this.toDomain(newSession);
  }

  async findById(id: Session['id']): Promise<Nullable<Session>> {
    const session = await this.repo.findOne({
      where: { id },
    });

    return session ? this.toDomain(session) : null;
  }

  async update(data: Session): Promise<Session> {
    const entity = this.repo.create(data);
    await this.repo.save(entity);

    return await this.findById(data.id);
  }

  async deleteById(id: Session['id']): Promise<void> {
    await this.repo.delete(id);
  }

  private toDomain(data: SessionEntity): Session {
    const user: User = {
      id: data.user.id,
      createdAt: data.user.createdAt,
      updatedAt: data.user.updatedAt,
      deletedAt: data.user.deletedAt,
      email: data.user.email,
      firstName: data.user.firstName,
      lastName: data.user.lastName,
      profileImageUrl: data.user.profileImageUrl,
      provider: data.user.provider,
      socialId: data.user.socialId,
      status: data.user.status,
    };

    return {
      id: data.id,
      user: user,
      hash: data.hash,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      deletedAt: data.deletedAt,
    };
  }

  private toPersistence(data: Session): SessionEntity {
    const session = new SessionEntity();
    session.id = data.id;
    session.hash = data.hash;
    session.createdAt = data.createdAt;
    session.updatedAt = data.updatedAt;
    session.deletedAt = data.deletedAt;
    const user = new UserEntity();
    user.id = data.user.id;
    session.user = user;

    return session;
  }
}
