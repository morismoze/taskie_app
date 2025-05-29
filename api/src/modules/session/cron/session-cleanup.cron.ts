import { Injectable } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { SessionRepository } from '../persistence/session.repository';

@Injectable()
export class SessionCleanupService {
  constructor(private readonly sessionRepository: SessionRepository) {}

  /**
   * We'll initally delete sessionsevery week on Sunday midnight.
   * We'll initally delete sessions which haven't been updated for more than
   * 7 days.
   */

  @Cron(CronExpression.EVERY_WEEK)
  async cleanupInactiveSessions() {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - 7);

    await this.sessionRepository.deleteInactiveSessionsBefore(
      cutoffDate.toISOString(),
    );
  }
}
