import { Session } from 'src/modules/session/domain/session.domain';
import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceUserMembershipDto } from 'src/modules/workspace/workspace-user-module/dto/workspace-user.dto';

export type JwtPayload = {
  userId: User['id'];
  roles: {
    workspaceId: WorkspaceUserMembershipDto['workspaceId'];
    role: WorkspaceUserMembershipDto['role'];
  }[];
  sessionId: Session['id'];
  iat: number; // Issued at - it's used by the Passport strategy
  exp: number; // Expiration - it's used by the Passport strategy)
  nbf: number; // Not before - it's used by the Passport strategy)
};
