import { Injectable, Scope } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { TransactionalRepository } from 'src/modules/unit-of-work/persistence/transactional.repository';
import { FindOptionsRelations, Repository } from 'typeorm';
import { Session } from '../../domain/session.domain';
import { SessionEntity } from '../session.entity';
import { TransactionalSessionRepository } from './transactional-session.repository';

@Injectable({ scope: Scope.REQUEST })
export class TransactionalSessionRepositoryImpl
  implements TransactionalSessionRepository
{
  constructor(
    @InjectRepository(SessionEntity)
    private readonly repo: Repository<SessionEntity>,
    private readonly transactionalRepository: TransactionalRepository,
  ) {}

  private get repositoryContext(): Repository<SessionEntity> {
    const transactional =
      this.transactionalRepository.getRepository(SessionEntity);

    // If there is a transactional repo available (a transaction bound to the
    // request is available), use it. Otherwise, use normal repo.
    return transactional || this.repo;
  }

  async create({
    data: { userId, hash, ipAddress, deviceModel, osVersion, appVersion },
    relations,
  }: {
    data: {
      userId: Session['user']['id'];
      hash: Session['hash'];
      ipAddress: Session['ipAddress'];
      deviceModel: Session['deviceModel'];
      osVersion: Session['osVersion'];
      appVersion: Session['appVersion'];
    };
    relations?: FindOptionsRelations<SessionEntity>;
  }): Promise<Nullable<SessionEntity>> {
    const persistenceModel = this.repositoryContext.create({
      appVersion,
      osVersion,
      deviceModel,
      ipAddress,
      hash,
      user: {
        id: userId,
      },
    });

    const savedEntity = await this.repositoryContext.save(persistenceModel);

    const newEntity = await this.repositoryContext.findOne({
      where: { id: savedEntity.id },
      relations,
    });

    return newEntity;
  }

  findById({
    id,
    relations,
  }: {
    id: Session['id'];
    relations?: FindOptionsRelations<SessionEntity>;
  }): Promise<Nullable<SessionEntity>> {
    return this.repositoryContext.findOne({
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
    const result = await this.repositoryContext.update(id, data);

    // Early return - provided ID does not exist
    if (result.affected === 0) {
      return null;
    }

    const newEntity = await this.findById({
      id,
      relations,
    });

    return newEntity;
  }

  async incrementAccessTokenVersionByUserId(
    id: Session['user']['id'],
  ): Promise<void> {
    const column: keyof SessionEntity = 'accessTokenVersion';

    await this.repositoryContext.increment({ user: { id } }, column, 1);
  }

  async delete(id: Session['id']): Promise<boolean> {
    const result = await this.repositoryContext.delete(id);
    return (result.affected ?? 0) > 0;
  }
}
