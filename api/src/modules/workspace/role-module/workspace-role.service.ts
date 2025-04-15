import { Injectable } from '@nestjs/common';
import { WorkspaceRole } from './persistence/workspace-role.entity';
import { Nullable } from 'src/common/types/nullable.type';
import { FindOneOptions } from 'typeorm';
import { RoleRepository } from './persistence/workspace-role.repository';

@Injectable()
export class RoleService {
  constructor(private readonly roleRepository: RoleRepository) {}

  async findOne(
    fields: FindOneOptions<WorkspaceRole>,
  ): Promise<Nullable<WorkspaceRole>> {
    return this.roleRepository.findOne(fields);
  }
}
