import { Module } from '@nestjs/common';
import { UserRepositoryImpl } from './user.repository.impl';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from './user.entity';
import { UserRepository } from './user.repository';
import { UnitOfWorkModule } from 'src/modules/unit-of-work/unit-of-work.module';

@Module({
  imports: [TypeOrmModule.forFeature([UserEntity]), UnitOfWorkModule],
  providers: [
    {
      provide: UserRepository,
      useClass: UserRepositoryImpl,
    },
  ],
  exports: [UserRepository],
})
export class UserPersistenceModule {}
