import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations } from 'typeorm';
import { Session } from '../../domain/session.domain';
import { SessionEntity } from '../session.entity';

/**
 * We use SessionRepository in CRON service which needs classic single instance
 * (singleton) provider. Because of that, SessionRepository can't use TransactionalRepository
 * because that provider is request scoped, meaning it is defined on each HTTP request - so
 * it exists only within the lifecycle of each HTTP request. CRON services are run outside of
 * HTTP request scope, so they can't have a provider which directly or transitively depends
 * on the request scoped provider. And because of all that we create another SessionRepository
 * specifically to be transactional.
 */

export abstract class TransactionalSessionRepository {
  abstract create({
    data,
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
  }): Promise<Nullable<SessionEntity>>;
}
