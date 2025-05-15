import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UnitOfWorkModule } from 'src/modules/unit-of-work/unit-of-work.module';
import { SessionEntity } from './session.entity';
import { SessionRepository } from './session.repository';
import { SessionRepositoryImpl } from './session.repository.impl';
import { TransactionalSessionRepository } from './transactional/transactional-session.repository';
import { TransactionalSessionRepositoryImpl } from './transactional/transactional-session.repository.impl';

@Module({
  imports: [TypeOrmModule.forFeature([SessionEntity]), UnitOfWorkModule],
  providers: [
    {
      provide: SessionRepository,
      useClass: SessionRepositoryImpl,
    },
    {
      provide: TransactionalSessionRepository,
      useClass: TransactionalSessionRepositoryImpl,
    },
  ],
  exports: [SessionRepository, TransactionalSessionRepository],
})
export class SessionPersistenceModule {}
