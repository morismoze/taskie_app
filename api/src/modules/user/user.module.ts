import { Module } from '@nestjs/common';
import { UnitOfWorkModule } from '../unit-of-work/unit-of-work.module';
import { WorkspaceUserModule } from '../workspace/workspace-user-module/workspace-user.module';
import { UserPersistenceModule } from './persistence/user-persistence.module';
import { UserController } from './user.controller';
import { UserService } from './user.service';

@Module({
  imports: [UserPersistenceModule, UnitOfWorkModule, WorkspaceUserModule],
  controllers: [UserController],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule {}
