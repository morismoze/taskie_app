import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WorkspaceRole } from './workspace-role.entity';
import { RoleRepository } from './workspace-role.repository';

@Module({
  imports: [TypeOrmModule.forFeature([WorkspaceRole])],
  providers: [RoleRepository],
  exports: [RoleRepository],
})
export class RolePersistenceModule {}
