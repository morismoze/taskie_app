import { Session } from 'src/modules/session/domain/session.domain';
import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceUser } from 'src/modules/workspace/workspace-user-module/domain/workspace-user.domain';

export type JwtPayload = {
  userId: User['id'];
  roles: {
    workspaceId: WorkspaceUser['workspace']['id'];
    role: WorkspaceUser['workspaceRole'];
  }[];
  sessionId: Session['id'];
  iat: number; // Issued at - it's used by the Passport strategy
  exp: number; // Expiration - it's used by the Passport strategy) = iat + expiresIn
  nbf: number; // Not before - it's used by the Passport strategy)
};
