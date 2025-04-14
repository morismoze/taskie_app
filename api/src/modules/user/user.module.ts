import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { RoleModule } from '../role/role.module';
import { StatusModule } from '../status/status.module';
import { UserPersistenceModule } from './persistence/user-persistence.module';

@Module({
  imports: [RoleModule, StatusModule, UserPersistenceModule],
  controllers: [UserController],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule {}
