import { Module } from '@nestjs/common';
import { RolePersistenceModule } from './persistence/role-persistence.module';
import { RoleService } from './role.service';

@Module({
  imports: [RolePersistenceModule],
  providers: [RoleService],
  exports: [RoleService],
})
export class RoleModule {}
