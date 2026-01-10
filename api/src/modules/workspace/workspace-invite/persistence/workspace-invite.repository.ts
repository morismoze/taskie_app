/**
 * Moved every method to transactionl repo except deleteExpiredInvites
 * since this method is used in a CRON job and there is no need to
 * have 2 different repos (transactional and non-transactional) in the
 * WorkspaceInviteService, so we just put all other methods, which are
 * actually used in the request lifecycle in the service class, to the
 * transactional repo.
 */
export abstract class WorkspaceInviteRepository {
  abstract deleteExpiredInvites(): Promise<void>;
}
