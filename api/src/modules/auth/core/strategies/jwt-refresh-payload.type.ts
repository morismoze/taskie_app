import { Session } from 'src/modules/session/domain/session.domain';

export type JwtRefreshPayload = {
  hash: Session['hash'];
  sessionId: Session['id'];
};
