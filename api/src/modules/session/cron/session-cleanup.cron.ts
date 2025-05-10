import { Injectable } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { SessionRepository } from '../persistence/session.repository';

@Injectable()
export class SessionCleanupService {
  constructor(private readonly sessionRepository: SessionRepository) {}

  /**
   * We'll initally delete sessions every 4th day at midnight.
   * We'll initally delete sessions which haven't been updated for more than
   * 7 days.
   */

  @Cron('0 0 */4 * *')
  async cleanupInactiveSessions() {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - 7);

    await this.sessionRepository.deleteInactiveSessionsBefore(cutoffDate);
  }
}
