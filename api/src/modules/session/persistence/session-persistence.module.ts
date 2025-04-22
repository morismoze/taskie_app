import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SessionEntity } from './session.entity';
import { SessionRepository } from './session.repository';
import { SessionRepositoryImpl } from './session.repository.impl';

@Module({
  imports: [TypeOrmModule.forFeature([SessionEntity])],
  providers: [
    {
      provide: SessionRepository,
      useClass: SessionRepositoryImpl,
    },
  ],
  exports: [SessionRepository],
})
export class SessionPersistenceModule {}
