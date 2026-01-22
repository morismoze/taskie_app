import { forwardRef, Module } from '@nestjs/common';
import { UnitOfWorkModule } from '../unit-of-work/unit-of-work.module';
import { WorkspaceModule } from '../workspace/workspace-module/workspace.module';
import { WorkspaceUserModule } from '../workspace/workspace-user-module/workspace-user.module';
import { UserPersistenceModule } from './persistence/user-persistence.module';
import { UserController } from './user.controller';
import { UserService } from './user.service';

@Module({
  imports: [
    UserPersistenceModule,
    UnitOfWorkModule,
    WorkspaceUserModule,
    // Using this because WorkspaceModule depends on the UserModule
    // so this defines to wait for WorkspaceModule to initalize
    // before trying to resolve it
    forwardRef(() => WorkspaceModule),
  ],
  controllers: [UserController],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule {}
