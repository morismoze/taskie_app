import { Session } from '../../domain/session.domain';

export abstract class NonTransactionalSessionRepository {
  abstract deleteInactiveSessionsBefore(
    cutoffDate: Session['updatedAt'],
  ): Promise<void>;
}
