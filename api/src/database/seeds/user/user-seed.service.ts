import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { RoleEnum } from 'src/modules/workspace/workspace-module/domain/workspace-role.enum';
import { StatusEnum } from 'src/modules/user/user-module/user-status.enum';
import { User } from 'src/modules/user/persistence/user.entity';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcryptjs';
import { Role } from 'src/modules/workspace/workspace-role.entity';
import { Status } from 'src/modules/user/user-status-module/persistence/user-status.entity';

@Injectable()
export class UserSeedService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    @InjectRepository(Role)
    private roleRepository: Repository<Role>,
    @InjectRepository(Status)
    private statusRepository: Repository<Status>,
  ) {}

  async run() {
    const countAdmin = await this.userRepository.count({
      where: {
        email: 'admin@example.com',
      },
    });

    if (!countAdmin) {
      const salt = await bcrypt.genSalt();
      const password = await bcrypt.hash('secret', salt);
      const adminRole = await this.roleRepository.findOne({
        where: { name: RoleEnum.manager },
      });
      const activeStatus = await this.statusRepository.findOne({
        where: { name: StatusEnum.active },
      });

      await this.userRepository.save(
        this.userRepository.create({
          username: 'Manager',
          email: 'admin@example.com',
          password,
          role: adminRole!,
          status: activeStatus!,
        }),
      );
    }

    const countUser = await this.userRepository.count({
      where: {
        email: 'john.doe@example.com',
      },
    });

    if (!countUser) {
      const salt = await bcrypt.genSalt();
      const password = await bcrypt.hash('secret', salt);
      const userRole = await this.roleRepository.findOne({
        where: { name: RoleEnum.member },
      });
      const activeStatus = await this.statusRepository.findOne({
        where: { name: StatusEnum.active },
      });

      await this.userRepository.save(
        this.userRepository.create({
          username: 'Member',
          email: 'john.doe@example.com',
          password,
          role: userRole!,
          status: activeStatus!,
        }),
      );
    }
  }
}
