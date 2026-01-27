import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UnitOfWorkModule } from 'src/modules/unit-of-work/unit-of-work.module';
import { NonTransactionalSessionRepository } from './non-transactional/non-transactional-session.repository';
import { NonTransactionalSessionRepositoryImpl } from './non-transactional/non-transactional-session.repository.impl';
import { SessionEntity } from './session.entity';
import { SessionRepository } from './session.repository';
import { SessionRepositoryImpl } from './session.repository.impl';

@Module({
  imports: [TypeOrmModule.forFeature([SessionEntity]), UnitOfWorkModule],
  providers: [
    {
      provide: NonTransactionalSessionRepository,
      useClass: NonTransactionalSessionRepositoryImpl,
    },
    {
      provide: SessionRepository,
      useClass: SessionRepositoryImpl,
    },
  ],
  exports: [NonTransactionalSessionRepository, SessionRepository],
})
export class SessionPersistenceModule {}
