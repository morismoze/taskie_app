import { Injectable } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { DateTime } from 'luxon';
import { SessionRepository } from '../persistence/session.repository';

@Injectable()
export class SessionCleanupService {
  constructor(private readonly sessionRepository: SessionRepository) {}

  /**
   * We'll initally delete sessions every week on Sunday midnight.
   * We'll initally delete sessions which haven't been updated for more than
   * 7 days.
   */

  @Cron(CronExpression.EVERY_WEEK)
  async cleanupInactiveSessions() {
    // Currently we've set refresh token TTL in the env to 30 days
    const REFRESH_TOKEN_TTL_DAYS = 30;
    const BUFFER_DAYS = 1;

    const cutoffDate = DateTime.now()

      .toUTC()
      .minus({ days: REFRESH_TOKEN_TTL_DAYS + BUFFER_DAYS })
      .toJSDate();

    await this.sessionRepository.deleteInactiveSessionsBefore(cutoffDate);
  }
}
