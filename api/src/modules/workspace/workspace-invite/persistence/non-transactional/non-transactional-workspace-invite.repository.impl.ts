import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DateTime } from 'luxon';
import { LessThan, Repository } from 'typeorm';
import { WorkspaceInviteEntity } from '../workspace-invite.entity';
import { NonTransactionalWorkspaceInviteRepository } from './non-transactional-workspace-invite.repository';

@Injectable()
export class NonTransactionalWorkspaceInviteRepositoryImpl
  implements NonTransactionalWorkspaceInviteRepository
{
  constructor(
    @InjectRepository(WorkspaceInviteEntity)
    private readonly repo: Repository<WorkspaceInviteEntity>,
  ) {}

  async deleteExpiredInvites(): Promise<void> {
    const now = DateTime.now().toUTC().toJSDate();
    await this.repo.delete({
      expiresAt: LessThan(now),
    });
  }
}
