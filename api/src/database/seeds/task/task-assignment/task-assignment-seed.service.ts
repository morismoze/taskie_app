import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { TaskAssignmentEntity } from 'src/modules/task/task-assignment/persistence/task-assignment.entity';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { TaskEntity } from 'src/modules/task/task-module/persistence/task.entity';
import { WorkspaceEntity } from 'src/modules/workspace/workspace-module/persistence/workspace.entity';
import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { Repository } from 'typeorm';

@Injectable()
export class TaskAssignmentSeedService {
  constructor(
    @InjectRepository(TaskAssignmentEntity)
    private readonly taskAssignmentRepository: Repository<TaskAssignmentEntity>,
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
        user: { firstName: 'Peter', lastName: 'Griffin' },
        workspace: {
          id: workspace1.id,
        },
        workspaceRole: WorkspaceUserRole.MEMBER,
      },
    });
    const workspaceUser2 = await this.workspaceUserRepository.findOne({
      where: {
        user: { firstName: 'Jim', lastName: 'Morrison' },
        workspace: {
          id: workspace2.id,
        },
        workspaceRole: WorkspaceUserRole.MEMBER,
      },
    });
    const workspaceUser3 = await this.workspaceUserRepository.findOne({
      where: {
        user: { firstName: 'Diego', lastName: 'Maradona' },
        workspace: {
          id: workspace1.id,
        },
        workspaceRole: WorkspaceUserRole.MEMBER,
      },
    });

    if (!workspaceUser1 || !workspaceUser2 || !workspaceUser3) {
      throw new Error('Missing workspace users for task seed');
    }

    const task1 = await this.taskRepository.findOne({
      where: {
        title: 'Implement User Authentication',
      },
    });
    const task2 = await this.taskRepository.findOne({
      where: {
        title: 'Design Dashboard UI',
      },
    });
    const task3 = await this.taskRepository.findOne({
      where: {
        title: 'Write API Documentation',
      },
    });
    const task4 = await this.taskRepository.findOne({
      where: {
        title: 'Setup CI/CD Pipeline',
      },
    });

    if (!task1 || !task2 || !task3 || !task4) {
      throw new Error('Missing tasks for task assignment seed');
    }

    const countTaskAssignment1 = await this.taskAssignmentRepository.count({
      where: {
        assignee: {
          id: workspaceUser1.id,
        },
        task: {
          title: task1.title,
        },
      },
    });

    if (countTaskAssignment1 === 0) {
      const taskAssignment1 = this.taskAssignmentRepository.create({
        task: task1,
        assignee: workspaceUser1,
        status: ProgressStatus.IN_PROGRESS,
      });
      await this.taskAssignmentRepository.save(taskAssignment1);
    }

    const countTaskAssignment12 = await this.taskAssignmentRepository.count({
      where: {
        assignee: {
          id: workspaceUser2.id,
        },
        task: {
          title: task1.title,
        },
      },
    });

    if (countTaskAssignment12 === 0) {
      // Two assignees on the same task
      const taskAssignment12 = this.taskAssignmentRepository.create({
        task: task1,
        assignee: workspaceUser3,
        status: ProgressStatus.IN_PROGRESS,
      });
      await this.taskAssignmentRepository.save(taskAssignment12);
    }

    const countTaskAssignment2 = await this.taskAssignmentRepository.count({
      where: {
        assignee: {
          id: workspaceUser3.id,
        },
        task: {
          title: task2.title,
        },
      },
    });

    if (countTaskAssignment2 === 0) {
      const taskAssignment2 = this.taskAssignmentRepository.create({
        task: task2,
        assignee: workspaceUser1,
        status: ProgressStatus.IN_PROGRESS,
      });
      await this.taskAssignmentRepository.save(taskAssignment2);
    }

    const countTaskAssignment3 = await this.taskAssignmentRepository.count({
      where: {
        assignee: {
          id: workspaceUser2.id,
        },
        task: {
          title: task3.title,
        },
      },
    });

    if (countTaskAssignment3 === 0) {
      const taskAssignment3 = this.taskAssignmentRepository.create({
        task: task3,
        assignee: workspaceUser2,
        status: ProgressStatus.IN_PROGRESS,
      });
      await this.taskAssignmentRepository.save(taskAssignment3);
    }

    const countTaskAssignment4 = await this.taskAssignmentRepository.count({
      where: {
        assignee: {
          id: workspaceUser2.id,
        },
        task: {
          title: task4.title,
        },
      },
    });

    if (countTaskAssignment4 === 0) {
      const taskAssignment4 = this.taskAssignmentRepository.create({
        task: task4,
        assignee: workspaceUser2,
        status: ProgressStatus.IN_PROGRESS,
      });
      await this.taskAssignmentRepository.save(taskAssignment4);
    }
  }
}
