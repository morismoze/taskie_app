import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { TaskEntity } from 'src/modules/task/task-module/persistence/task.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { Repository } from 'typeorm';

@Injectable()
export class TaskSeedService {
  constructor(
    @InjectRepository(TaskEntity)
    private readonly taskRepository: Repository<TaskEntity>,
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

    if (!workspaceUser1 || !workspaceUser2) {
      throw new Error('Missing workspace users for task seed');
    }

    const countTask1 = await this.taskRepository.count({
      where: {
        title: 'Implement User Authentication',
      },
    });

    if (countTask1 === 0) {
      const task1Entity = this.taskRepository.create({
        workspace: workspace1,
        title: 'Implement User Authentication',
        rewardPoints: 50,
        description:
          'Full authentication flow for users, including JWT and refresh tokens.',
        dueDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
        createdBy: workspaceUser1,
      });
      await this.taskRepository.save(task1Entity);
    }

    const countTask2 = await this.taskRepository.count({
      where: {
        title: 'Design Dashboard UI',
      },
    });

    if (countTask2 === 0) {
      const task2Entity = this.taskRepository.create({
        workspace: workspace1,
        title: 'Design Dashboard UI',
        rewardPoints: 30,
        description: 'Create initial user interface for the main dashboard.',
        dueDate: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000).toISOString(),
        createdBy: workspaceUser1,
      });
      await this.taskRepository.save(task2Entity);
    }

    const countTask3 = await this.taskRepository.count({
      where: {
        title: 'Write API Documentation',
      },
    });

    if (countTask3 === 0) {
      const task3Entity = this.taskRepository.create({
        workspace: workspace2,
        title: 'Write API Documentation',
        rewardPoints: 20,
        description:
          'Document all REST API endpoints for user, workspace, and tasks.',
        dueDate: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(), // Overdue
        createdBy: workspaceUser2,
      });
      await this.taskRepository.save(task3Entity);
    }

    const countTask4 = await this.taskRepository.count({
      where: {
        title: 'Setup CI/CD Pipeline',
      },
    });

    if (countTask4 === 0) {
      const task4Entity = this.taskRepository.create({
        workspace: workspace2,
        title: 'Setup CI/CD Pipeline',
        rewardPoints: 40,
        description:
          'Configure continuous integration and deployment for the backend.',
        dueDate: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000).toISOString(),
        createdBy: workspaceUser2,
      });
      await this.taskRepository.save(task4Entity);
    }
  }
}
