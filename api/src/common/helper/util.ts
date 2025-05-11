import { randomBytes } from 'crypto';

export const generateUniqueToken = (length: number): string => {
  return randomBytes(Math.ceil(length / 2))
    .toString('hex')
    .slice(0, length);
};

export const getAppWorkspaceJoinDeepLink = (inviteToken: string) => {
  return `taskie://workspaces/join/${inviteToken}`;
};
