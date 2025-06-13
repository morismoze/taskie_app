import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { UserPersistenceModule } from './persistence/user-persistence.module';
import { UnitOfWorkModule } from '../unit-of-work/unit-of-work.module';

@Module({
  imports: [UserPersistenceModule, UnitOfWorkModule],
  controllers: [UserController],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule {}
