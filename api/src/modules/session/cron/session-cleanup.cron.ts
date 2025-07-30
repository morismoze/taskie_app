import { Injectable } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { DateTime } from 'luxon';
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
    const cutoffDate = DateTime.now().minus({ days: 7 }).toJSDate();

    await this.sessionRepository.deleteInactiveSessionsBefore(cutoffDate);
  }
}
