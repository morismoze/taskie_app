import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations } from 'typeorm';
import { Session } from '../domain/session.domain';
import { SessionEntity } from './session.entity';

export abstract class SessionRepository {
  abstract findById({
    id,
    relations,
  }: {
    id: Session['id'];
    relations?: FindOptionsRelations<SessionEntity>;
  }): Promise<Nullable<SessionEntity>>;

  abstract update({
    id,
    data,
  }: {
    id: Session['id'];
    data: Partial<
      Omit<Session, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt' | 'user'>
    >;
  }): Promise<Nullable<SessionEntity>>;

  abstract incrementAccessTokenVersionByUserId(
    id: Session['user']['id'],
  ): Promise<void>;

  abstract deleteById(id: Session['id']): Promise<Nullable<void>>;

  /**
   * This is used as part of the session deletion CRON job
   */
  abstract deleteInactiveSessionsBefore(
    cutoffDate: Session['updatedAt'],
  ): Promise<void>;
}
