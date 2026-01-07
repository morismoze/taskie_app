import { Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { TransactionalRepository } from 'src/modules/unit-of-work/persistence/transactional.repository';
import { FindOptionsRelations, Repository } from 'typeorm';
import { Session } from '../../domain/session.domain';
import { SessionEntity } from '../session.entity';
import { TransactionalSessionRepository } from './transactional-session.repository';

@Injectable()
export class TransactionalSessionRepositoryImpl
  implements TransactionalSessionRepository
{
  constructor(
    private readonly transactionalRepository: TransactionalRepository,
  ) {}

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
    const persistenceModel = this.transactionalSessionRepo.create({
      appVersion,
      osVersion,
      deviceModel,
      ipAddress,
      hash,
      user: {
        id: userId,
      },
    });

    const savedEntity =
      await this.transactionalSessionRepo.save(persistenceModel);

    const newEntity = await this.transactionalSessionRepo.findOne({
      where: { id: savedEntity.id },
      relations,
    });

    return newEntity;
  }

  private get transactionalSessionRepo(): Repository<SessionEntity> {
    // Transactionl repo will be available because we use this
    // method inside a unitOfWork
    return this.transactionalRepository.getRepository(SessionEntity)!;
  }
}
