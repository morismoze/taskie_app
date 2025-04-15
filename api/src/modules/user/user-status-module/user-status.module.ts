import { Module } from '@nestjs/common';
import { UserStatusPersistenceModule } from './persistence/user-status-persistence.module';
import { UserStatusService } from './user-status.service';

@Module({
  imports: [UserStatusPersistenceModule],
  providers: [UserStatusService],
  exports: [UserStatusService],
})
export class UserStatusModule {}
