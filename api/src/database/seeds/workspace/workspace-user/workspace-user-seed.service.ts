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
    const workspace1 = await this.workspaceRepository.findOne({
      where: { name: 'Development Team Alpha' },
    });
    const workspace2 = await this.workspaceRepository.findOne({
      where: { name: 'Marketing Outreach Beta' },
    });

    if (!user1 || !user2 || !workspace1 || !workspace2) {
      throw new Error('Missing users or workspaces for workspace user seed');
    }

    const countWorkspaceUser1 = await this.workspaceUserRepository.count({
      where: {
        user: user1,
      },
    });

    if (countWorkspaceUser1 === 0) {
      const workspaceUser1 = this.workspaceUserRepository.create({
        workspace: workspace1,
        user: user1,
        workspaceRole: WorkspaceUserRole.MANAGER,
        status: WorkspaceUserStatus.ACTIVE,
        createdBy: null,
      });
      await this.workspaceUserRepository.save(workspaceUser1);
    }

    const countWorkspaceUser2 = await this.workspaceUserRepository.count({
      where: {
        user: user2,
      },
    });

    if (countWorkspaceUser2 === 0) {
      const workspaceUser2 = this.workspaceUserRepository.create({
        workspace: workspace2,
        user: user2,
        workspaceRole: WorkspaceUserRole.MANAGER,
        status: WorkspaceUserStatus.ACTIVE,
        createdBy: null,
      });
      await this.workspaceUserRepository.save(workspaceUser2);
    }
  }
}
