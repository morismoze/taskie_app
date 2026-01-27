import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations } from 'typeorm';
import { Session } from '../domain/session.domain';
import { SessionEntity } from './session.entity';

export abstract class SessionRepository {
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
