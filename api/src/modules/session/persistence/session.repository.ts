import { Nullable } from 'src/common/types/nullable.type';
import { Session } from '../domain/session.domain';

export abstract class SessionRepository {
  abstract create(
    data: Omit<Session, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>,
  ): Promise<Nullable<Session>>;

  abstract findById(id: Session['id']): Promise<Nullable<Session>>;

  abstract update(
    id: Session['id'],
    data: Partial<
      Omit<Session, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>
    >,
  ): Promise<Nullable<Session>>;

  abstract deleteById(id: Session['id']): Promise<void>;
}
