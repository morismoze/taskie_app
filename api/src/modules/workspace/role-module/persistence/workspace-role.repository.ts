import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { WorkspaceRole } from 'src/modules/workspace/role-module/persistence/workspace-role.entity';

@Injectable()
export class RoleRepository extends Repository<WorkspaceRole> {
  constructor(
    @InjectRepository(WorkspaceRole)
    private readonly roleRepository: Repository<WorkspaceRole>,
  ) {
    super(
      roleRepository.target,
      roleRepository.manager,
      roleRepository.queryRunner,
    );
  }
}
