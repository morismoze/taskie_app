import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { GoalEntity } from 'src/modules/goal/persistence/goal.entity';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { Repository } from 'typeorm';

@Injectable()
export class GoalSeedService {
  constructor(
    @InjectRepository(GoalEntity)
    private readonly goalRepository: Repository<GoalEntity>,
    @InjectRepository(WorkspaceEntity)
    private readonly workspaceRepository: Repository<WorkspaceEntity>,
    @InjectRepository(WorkspaceUserEntity)
    private readonly workspaceUserRepository: Repository<WorkspaceUserEntity>,
  ) {}

  async run() {
    const workspace1 = await this.workspaceRepository.findOne({
      where: { name: 'Development Team Alpha' },
    });
    const workspace2 = await this.workspaceRepository.findOne({
      where: { name: 'Marketing Outreach Beta' },
    });

    if (!workspace1 || !workspace2) {
      throw new Error('Missing workspaces for task seed');
    }

    const workspaceUser1 = await this.workspaceUserRepository.findOne({
      where: {
        user: { email: 'john.doe@example.com' },
        workspace: {
          id: workspace1.id,
        },
        workspaceRole: WorkspaceUserRole.MANAGER,
      },
    });
    const workspaceUser2 = await this.workspaceUserRepository.findOne({
      where: {
        user: { email: 'jane.smith@example.com' },
        workspace: {
          id: workspace2.id,
        },
        workspaceRole: WorkspaceUserRole.MANAGER,
      },
    });
    const workspaceUser3 = await this.workspaceUserRepository.findOne({
      where: {
        user: { firstName: 'Peter', lastName: 'Griffin' },
        workspace: {
          id: workspace1.id,
        },
        workspaceRole: WorkspaceUserRole.MEMBER,
      },
    });
    const workspaceUser4 = await this.workspaceUserRepository.findOne({
      where: {
        user: { firstName: 'Jim', lastName: 'Morrison' },
        workspace: {
          id: workspace2.id,
        },
        workspaceRole: WorkspaceUserRole.MEMBER,
      },
    });
    const workspaceUser5 = await this.workspaceUserRepository.findOne({
      where: {
        user: { firstName: 'Diego', lastName: 'Maradona' },
        workspace: {
          id: workspace1.id,
        },
        workspaceRole: WorkspaceUserRole.MEMBER,
      },
    });

    if (
      !workspaceUser1 ||
      !workspaceUser2 ||
      !workspaceUser3 ||
      !workspaceUser4 ||
      !workspaceUser5
    ) {
      throw new Error('Missing workspace users for task seed');
    }

    const countGoal1 = await this.goalRepository.count({
      where: {
        assignee: {
          id: workspaceUser3.id,
        },
        workspace: {
          id: workspace1.id,
        },
      },
    });

    if (countGoal1 === 0) {
      const goal1 = this.goalRepository.create({
        workspace: workspace1,
        assignee: workspaceUser3,
        title: 'Complete Onboarding Tasks',
        description:
          'Finish all initial setup tasks for the project. Reach 100 points.',
        requiredPoints: 100,
        status: ProgressStatus.IN_PROGRESS,
        createdBy: workspaceUser1,
      });
      await this.goalRepository.save(goal1);
    }

    const countGoal2 = await this.goalRepository.count({
      where: {
        assignee: {
          id: workspaceUser5.id,
        },
        workspace: {
          id: workspace1.id,
        },
      },
    });

    if (countGoal2 === 0) {
      const goal2 = this.goalRepository.create({
        workspace: workspace1,
        assignee: workspaceUser5,
        title: 'Master NestJS Basics',
        description:
          'Accumulate 250 points by completing NestJS-related tasks.',
        requiredPoints: 250,
        status: ProgressStatus.IN_PROGRESS,
        createdBy: workspaceUser1,
      });
      await this.goalRepository.save(goal2);
    }

    const countGoal3 = await this.goalRepository.count({
      where: {
        assignee: {
          id: workspaceUser4.id,
        },
        workspace: {
          id: workspace2.id,
        },
      },
    });

    if (countGoal3 === 0) {
      const goal3 = this.goalRepository.create({
        workspace: workspace2,
        assignee: workspaceUser4,
        title: 'Achieve Q2 Team Goal',
        description:
          'Ensure the team reaches its Q2 development target of 500 points.',
        requiredPoints: 500,
        status: ProgressStatus.IN_PROGRESS,
        createdBy: workspaceUser4,
      });
      await this.goalRepository.save(goal3);
    }
  }
}
