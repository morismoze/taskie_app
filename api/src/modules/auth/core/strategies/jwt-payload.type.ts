import { Session } from 'src/modules/session/domain/session.domain';
import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceUser } from 'src/modules/workspace/workspace-user-module/domain/workspace-user.domain';

export type JwtPayload = {
  sub: User['id'];
  roles: {
    workspaceId: WorkspaceUser['workspace']['id'];
    role: WorkspaceUser['workspaceRole'];
  }[];
  sessionId: Session['id'];
};
