import { randomBytes } from 'crypto';
import { User } from 'src/modules/user/domain/user.domain';

export const generateUniqueToken = (length: number): string => {
  return randomBytes(Math.ceil(length / 2))
    .toString('hex')
    .slice(0, length);
};

export const getAppWorkspaceJoinDeepLink = (
  cnameUrl: string,
  inviteToken: string,
) => {
  return `${cnameUrl}/workspaces/join/${inviteToken}`;
};

export const checkIsVirtualUser = ({ user }: { user: User }) => {
  return user.email === null;
};
