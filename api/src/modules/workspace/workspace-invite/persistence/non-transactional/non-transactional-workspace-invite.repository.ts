export abstract class NonTransactionalWorkspaceInviteRepository {
  abstract deleteExpiredInvites(): Promise<void>;
}
