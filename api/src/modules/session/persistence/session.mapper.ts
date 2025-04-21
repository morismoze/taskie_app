import { Session } from '../domain/session.domain';
import { SessionEntity } from './session.entity';

export class SessionMapper {
  static toDomain(data: SessionEntity): Session {
    return {
      id: data.id,
      user: {
        id: data.user.id,
      },
      hash: data.hash,
    };
  }
}
