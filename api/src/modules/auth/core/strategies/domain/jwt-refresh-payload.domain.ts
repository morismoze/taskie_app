import { Session } from 'src/modules/session/domain/session.domain';

export type JwtRefreshPayload = {
  hash: Session['hash'];
  sessionId: Session['id'];
  iat: number; // Issued at - it's used by the Passport strategy
  exp: number; // Expiration - it's used by the Passport strategy) = iat + expiresIn
  nbf: number; // Not before - it's used by the Passport strategy)
};
