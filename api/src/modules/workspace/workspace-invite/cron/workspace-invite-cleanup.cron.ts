import { Injectable } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { WorkspaceInviteRepository } from '../persistence/workspace-invite.repository';

@Injectable()
export class WorkspaceInviteCleanupService {
  constructor(
    private readonly workspaceInviteRepository: WorkspaceInviteRepository,
  ) {}

  /**
   * We'll initally delete invites every week on Sunday midnight at midnight.
   * We'll initally delete invites which are expired for more than
   * 4 days.
   */

  @Cron(CronExpression.EVERY_WEEK)
  async cleanupInactiveSessions() {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - 4);

    await this.workspaceInviteRepository.deleteInactiveInvitesBefore(
      cutoffDate,
    );
  }
}
