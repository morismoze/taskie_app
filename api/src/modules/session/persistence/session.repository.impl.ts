import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations, Repository } from 'typeorm';
import { Session } from '../domain/session.domain';
import { SessionEntity } from './session.entity';
import { SessionRepository } from './session.repository';

@Injectable()
export class SessionRepositoryImpl implements SessionRepository {
  constructor(
    @InjectRepository(SessionEntity)
    private readonly repo: Repository<SessionEntity>,
  ) {}

  async create({
    data: {
      userId,
      hash,
      ipAddress,
      deviceId,
      deviceModel,
      osVersion,
      appVersion,
    },
    relations,
  }: {
    data: {
      userId: Session['user']['id'];
      hash: Session['hash'];
      ipAddress: Session['ipAddress'];
      deviceId: Session['deviceId'];
      deviceModel: Session['deviceModel'];
      osVersion: Session['osVersion'];
      appVersion: Session['appVersion'];
    };
    relations?: FindOptionsRelations<SessionEntity>;
  }): Promise<Nullable<SessionEntity>> {
    const persistenceModel = this.repo.create({
      appVersion,
      osVersion,
      deviceId,
      deviceModel,
      ipAddress,
      hash,
      user: {
        id: userId,
      },
    });

    const savedEntity = await this.repo.save(persistenceModel);

    const newEntity = await this.findById({ id: savedEntity.id, relations });

    return newEntity;
  }

  async findById({
    id,
    relations,
  }: {
    id: Session['id'];
    relations?: FindOptionsRelations<SessionEntity>;
  }): Promise<Nullable<SessionEntity>> {
    return await this.repo.findOne({
      where: { id },
      relations,
    });
  }

  async update({
    id,
    data,
    relations,
  }: {
    id: Session['id'];
    data: Partial<
      Omit<Session, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt' | 'user'>
    >;
    relations?: FindOptionsRelations<SessionEntity>;
  }): Promise<Nullable<SessionEntity>> {
    const persistenceModel = this.repo.create({ id, ...data });

    await this.repo.save(persistenceModel);

    return this.findById({ id, relations });
  }

  async deleteById(id: Session['id']): Promise<void> {
    await this.repo.delete(id);
  }
}
