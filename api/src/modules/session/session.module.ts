import { Module } from '@nestjs/common';
import { SessionPersistenceModule } from './persistence/session-persistence.module';
import { SessionService } from './session.service';

@Module({
  imports: [SessionPersistenceModule],
  providers: [SessionService],
  exports: [SessionService],
})
export class SessionModule {}
