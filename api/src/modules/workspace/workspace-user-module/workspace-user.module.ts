import { Module } from '@nestjs/common';
import { UnitOfWorkModule } from 'src/modules/unit-of-work/unit-of-work.module';
import { WorkspaceUserPersistenceModule } from './persistence/workspace-user-persistence.module';
import { WorkspaceUserService } from './workspace-user.service';

@Module({
  imports: [WorkspaceUserPersistenceModule, UnitOfWorkModule],
  providers: [WorkspaceUserService],
  exports: [WorkspaceUserService],
})
export class WorkspaceUserModule {}
