import { Module } from '@nestjs/common';
import { StatusPersistenceModule } from './persistence/status-persistence.module';
import { StatusService } from './status.service';

@Module({
  imports: [StatusPersistenceModule],
  providers: [StatusService],
  exports: [StatusService],
})
export class StatusModule {}
