import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations } from 'typeorm';
import { Session } from '../../domain/session.domain';
import { SessionEntity } from '../session.entity';

/**
 * We use plain SessionRepository in CRON service which needs classic single instance
 * (singleton) provider. Because of that, SessionRepository can't use TransactionalRepository
 * because TransactionalRepository is request scoped, meaning it is defined on each HTTP request
 * - it exists only within the lifecycle of each HTTP request. CRON services are run outside of
 * HTTP request scope, so they can't have a provider which directly or transitively depends
 * on the request scoped provider. And because of all that we create another SessionRepository
 * specifically to be transactional.
 */

export abstract class TransactionalSessionRepository {
  abstract create(args: {
    data: {
      userId: Session['user']['id'];
      hash: Session['hash'];
      ipAddress: Session['ipAddress'];
      deviceModel: Session['deviceModel'];
      osVersion: Session['osVersion'];
      appVersion: Session['appVersion'];
    };
    relations?: FindOptionsRelations<SessionEntity>;
  }): Promise<Nullable<SessionEntity>>;

  abstract findById(args: {
    id: Session['id'];
    relations?: FindOptionsRelations<SessionEntity>;
  }): Promise<Nullable<SessionEntity>>;

  abstract update(args: {
    id: Session['id'];
    data: Partial<
      Omit<Session, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt' | 'user'>
    >;
  }): Promise<Nullable<SessionEntity>>;

  abstract incrementAccessTokenVersionByUserId(
    id: Session['user']['id'],
  ): Promise<void>;

  abstract delete(id: Session['id']): Promise<boolean>;
}
