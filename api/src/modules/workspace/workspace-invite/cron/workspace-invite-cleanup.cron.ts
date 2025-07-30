import { Injectable } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { WorkspaceInviteRepository } from '../persistence/workspace-invite.repository';

@Injectable()
export class WorkspaceInviteCleanupService {
  constructor(
    private readonly workspaceInviteRepository: WorkspaceInviteRepository,
  ) {}

  /**
   * We'll initally delete expired invites every week on Sunday at midnight.
   */

  @Cron(CronExpression.EVERY_WEEK)
  async cleanupExpiredInvites() {
    await this.workspaceInviteRepository.deleteExpiredInvites();
  }
}
