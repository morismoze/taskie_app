import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { Repository } from 'typeorm';

@Injectable()
export class WorkspaceSeedService {
  constructor(
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

    if (!user1 || !user2) {
      throw new Error('Missing users for workspace seed');
    }

    const countWorkspace1 = await this.workspaceRepository.count({
      where: {
        name: 'Development Team Alpha',
      },
    });

    if (countWorkspace1 === 0) {
      const workspace1 = this.workspaceRepository.create({
        name: 'Development Team Alpha',
        description:
          'Primary workspace for software development. Focus on new features.',
        pictureUrl: 'https://example.com/workspace-alpha.png',
        createdBy: user1,
      });
      await this.workspaceRepository.save(workspace1);
    }

    const countWorkspace2 = await this.workspaceRepository.count({
      where: {
        name: 'Marketing Outreach Beta',
      },
    });

    if (countWorkspace2 === 0) {
      const workspace1 = this.workspaceRepository.create({
        name: 'Marketing Outreach Beta',
        description:
          'Workspace for planning and executing marketing campaigns.',
        pictureUrl: 'https://example.com/workspace-beta.png',
        createdBy: user2,
      });
      await this.workspaceRepository.save(workspace1);
    }
  }
}
