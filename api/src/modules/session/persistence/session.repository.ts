import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { Repository } from 'typeorm';
import { Session } from '../domain/session.domain';
import { SessionEntity } from './session.entity';
import { SessionMapper } from './session.mapper';

@Injectable()
export class SessionRepository {
  constructor(
    @InjectRepository(SessionEntity)
    private readonly repo: Repository<SessionEntity>,
  ) {}

  async create(
    userId: Session['user']['id'],
    hash: Session['hash'],
  ): Promise<Nullable<Session>> {
    const entity = this.repo.create({
      hash: hash,
      user: { id: userId }, // TypeORM supports setting relations by reference
    });

    const savedEntity = await this.repo.save(entity);

    const newEntity = await this.repo.findOne({
      where: { id: savedEntity.id },
      relations: ['user', 'workspace'],
    });

    return newEntity !== null ? SessionMapper.toDomain(newEntity) : null;
  }

  async findById(id: Session['id']): Promise<Nullable<Session>> {
    const session = await this.repo.findOne({
      where: { id },
      relations: ['user'],
    });

    return session ? SessionMapper.toDomain(session) : null;
  }

  async update(data: Session): Promise<Nullable<Session>> {
    const entity = this.repo.create(data);

    await this.repo.save(entity);

    return this.findById(data.id);
  }

  async deleteById(id: Session['id']): Promise<void> {
    await this.repo.delete(id);
  }
}
