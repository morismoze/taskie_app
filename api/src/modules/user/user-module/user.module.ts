import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { UserStatusModule } from '../user-status-module/user-status.module';
import { UserPersistenceModule } from './persistence/user-persistence.module';

@Module({
  imports: [UserStatusModule, UserPersistenceModule],
  controllers: [UserController],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule {}
