import { Module } from '@nestjs/common';
import { SessionCleanupService } from './cron/session-cleanup.cron';
import { SessionPersistenceModule } from './persistence/session-persistence.module';
import { SessionService } from './session.service';

@Module({
  imports: [SessionPersistenceModule],
  providers: [SessionService, SessionCleanupService],
  exports: [SessionService],
})
export class SessionModule {}
