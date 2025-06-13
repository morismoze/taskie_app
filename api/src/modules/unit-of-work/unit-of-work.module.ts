import { Module } from '@nestjs/common';
import { TransactionalRepository } from './persistence/transactional.repository';
import { UnitOfWorkService } from './unit-of-work.service';

@Module({
  providers: [UnitOfWorkService, TransactionalRepository],
  exports: [UnitOfWorkService, TransactionalRepository],
})
export class UnitOfWorkModule {}
