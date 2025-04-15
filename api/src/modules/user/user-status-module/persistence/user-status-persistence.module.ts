import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserStatus } from './user-status.entity';
import { UserStatusRepository } from './user-status.repository';

@Module({
  imports: [TypeOrmModule.forFeature([UserStatus])],
  providers: [UserStatusRepository],
  exports: [UserStatusRepository],
})
export class UserStatusPersistenceModule {}
