import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { Repository } from 'typeorm';
import { Session } from '../domain/session.domain';
import { SessionEntity } from './session.entity';
import { SessionMapper } from './session.mapper';
import { SessionRepository } from './session.repository';

@Injectable()
export class SessionRepositoryImpl implements SessionRepository {
  constructor(
    @InjectRepository(SessionEntity)
    private readonly repo: Repository<SessionEntity>,
  ) {}

  /**
   * This method implements the create method in a smart way.
   * The contract omits id, createdAt, updatedAt, deletedAt because these properties
   * are auto generated/updated by Typeorm. But in this implementation we type the data
   * as the entire Session domain (Session domain = Session entity), and this works
   * because Typeorm supports partial updating meaning all undefined properties are skipped
   * on save() method.
   */
  async create(data: Session): Promise<Nullable<Session>> {
    const persistenceModel = SessionMapper.toPersistence(data);

    const savedEntity = await this.repo.save(persistenceModel);

    const newEntity = await this.repo.findOne({
      where: { id: savedEntity.id },
      relations: ['user'],
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

  async update(id: Session['id'], data: Session): Promise<Nullable<Session>> {
    const persistenceModel = SessionMapper.toPersistence(data);

    await this.repo.save(persistenceModel);

    return this.findById(id);
  }

  async deleteById(id: Session['id']): Promise<void> {
    await this.repo.delete(id);
  }
}
