import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Role } from 'src/modules/workspace/workspace-role.entity';
import { RoleEnum } from 'src/modules/workspace/workspace-module/domain/workspace-role.enum';
import { Repository } from 'typeorm';

@Injectable()
export class RoleSeedService {
  constructor(
    @InjectRepository(Role)
    private repository: Repository<Role>,
  ) {}

  async run() {
    const countAdmin = await this.repository.count({
      where: {
        name: RoleEnum.manager,
      },
    });

    if (!countAdmin) {
      await this.repository.save(
        this.repository.create({
          name: RoleEnum.manager,
        }),
      );
    }
  }
}
