import { Module } from '@nestjs/common';
import { UnitOfWorkModule } from '../unit-of-work/unit-of-work.module';
import { SessionCleanupService } from './cron/session-cleanup.cron';
import { SessionPersistenceModule } from './persistence/session-persistence.module';
import { SessionService } from './session.service';

@Module({
  imports: [SessionPersistenceModule, UnitOfWorkModule],
  providers: [SessionService, SessionCleanupService],
  exports: [SessionService],
})
export class SessionModule {}
