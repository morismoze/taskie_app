import { Module } from '@nestjs/common';
import { RolePersistenceModule } from './persistence/workspace-role-persistence.module';
import { RoleService } from './workspace-role.service';

@Module({
  imports: [RolePersistenceModule],
  providers: [RoleService],
  exports: [RoleService],
})
export class RoleModule {}
