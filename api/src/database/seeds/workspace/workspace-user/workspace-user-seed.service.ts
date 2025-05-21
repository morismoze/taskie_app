import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-status.enum';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { Repository } from 'typeorm';

@Injectable()
export class WorkspaceUserSeedService {
  constructor(
    @InjectRepository(WorkspaceUserEntity)
    private readonly workspaceUserRepository: Repository<WorkspaceUserEntity>,
    @InjectRepository(WorkspaceEntity)
    private readonly workspaceRepository: Repository<WorkspaceEntity>,
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
  ) {}

  async run() {
    const user1 = await this.userRepository.findOne({
      where: { email: 'john.doe@example.com' },
    });
    const user2 = await this.userRepository.findOne({
      where: { email: 'jane.smith@example.com' },
    });
    const user3 = await this.userRepository.findOne({
      where: { email: 'peter.griffin@example.com' },
    });
    const user4 = await this.userRepository.findOne({
      where: { email: 'jim.morisson@example.com' },
    });
    const user5 = await this.userRepository.findOne({
      where: { email: 'diego.maradona@example.com' },
    });

    if (!user1 || !user2 || !user3 || !user4 || !user5) {
      throw new Error('Missing users for workspace user seed');
    }

    const workspace1 = await this.workspaceRepository.findOne({
      where: { name: 'Development Team Alpha' },
    });
    const workspace2 = await this.workspaceRepository.findOne({
      where: { name: 'Marketing Outreach Beta' },
    });

    if (!workspace1 || !workspace2) {
      throw new Error('Missing workspaces for workspace user seed');
    }

    let workspaceUser1 = await this.workspaceUserRepository.findOne({
      where: {
        user: user1,
      },
    });

    if (!workspaceUser1) {
      workspaceUser1 = this.workspaceUserRepository.create({
        workspace: workspace1,
        user: user1,
        workspaceRole: WorkspaceUserRole.MANAGER,
        status: WorkspaceUserStatus.ACTIVE,
        createdBy: null,
      });
      await this.workspaceUserRepository.save(workspaceUser1);
    }

    let workspaceUser2 = await this.workspaceUserRepository.findOne({
      where: {
        user: user2,
      },
    });

    if (!workspaceUser2) {
      workspaceUser2 = this.workspaceUserRepository.create({
        workspace: workspace2,
        user: user2,
        workspaceRole: WorkspaceUserRole.MANAGER,
        status: WorkspaceUserStatus.ACTIVE,
        createdBy: null,
      });
      await this.workspaceUserRepository.save(workspaceUser2);
    }

    const workspaceUser3 = await this.workspaceUserRepository.findOne({
      where: {
        user: user3,
      },
    });

    if (!workspaceUser3) {
      const workspaceUser3 = this.workspaceUserRepository.create({
        workspace: workspace1,
        user: user3,
        workspaceRole: WorkspaceUserRole.MEMBER,
        status: WorkspaceUserStatus.ACTIVE,
        createdBy: workspaceUser1,
      });
      await this.workspaceUserRepository.save(workspaceUser3);
    }

    const workspaceUser4 = await this.workspaceUserRepository.findOne({
      where: {
        user: user4,
      },
    });

    if (!workspaceUser4) {
      const workspaceUser4 = this.workspaceUserRepository.create({
        workspace: workspace2,
        user: user4,
        workspaceRole: WorkspaceUserRole.MEMBER,
        status: WorkspaceUserStatus.ACTIVE,
        createdBy: workspaceUser2,
      });
      await this.workspaceUserRepository.save(workspaceUser4);
    }

    const workspaceUser5 = await this.workspaceUserRepository.findOne({
      where: {
        user: user4,
      },
    });

    if (!workspaceUser5) {
      const workspaceUser5 = this.workspaceUserRepository.create({
        workspace: workspace1,
        user: user5,
        workspaceRole: WorkspaceUserRole.MEMBER,
        status: WorkspaceUserStatus.ACTIVE,
        createdBy: workspaceUser1,
      });
      await this.workspaceUserRepository.save(workspaceUser5);
    }
  }
}
