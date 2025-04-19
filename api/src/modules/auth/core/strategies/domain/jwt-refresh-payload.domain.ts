import { Session } from 'src/modules/session/domain/session.domain';

export type JwtRefreshPayload = {
  hash: Session['hash'];
  sessionId: Session['id'];
  iat: number; // The timestamp when the token was issued (in seconds since epoch)
  exp: number; // The timestamp when the token expires (iat + expiresIn)
};
