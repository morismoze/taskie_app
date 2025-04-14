import { Injectable } from '@nestjs/common';
import { Role } from './persistence/role.entity';
import { Nullable } from 'src/common/types/nullable.type';
import { FindOneOptions } from 'typeorm';
import { RoleRepository } from './persistence/role.repository';

@Injectable()
export class RoleService {
  constructor(private readonly roleRepository: RoleRepository) {}

  async findOne(fields: FindOneOptions<Role>): Promise<Nullable<Role>> {
    return this.roleRepository.findOne(fields);
  }
}
