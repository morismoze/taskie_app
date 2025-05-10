import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { ProgressStatus } from '../task-module/domain/progress-status.enum';
import { TaskAssignmentCore } from './domain/task-assignment-core.domain';
import { TaskAssignment } from './domain/task-assignment.domain';
import { TaskAssignmentRepository } from './persistence/task-assignment.repository';

@Injectable()
export class TaskAssignmentService {
  constructor(
    private readonly taskAssignmentRepository: TaskAssignmentRepository,
  ) {}

  async getAccumulatedPointsForWorkspaceUser(
    workspaceUserId: string,
    workspaceId: string,
  ): Promise<number> {
    const completedAssignments =
      await this.taskAssignmentRepository.findyAllByAssigneeIdAndWorkspaceIdAndStatus(
        {
          workspaceUserId,
          workspaceId,
          status: ProgressStatus.COMPLETED,
        },
      );

    let totalPoints = 0;
    for (const assignment of completedAssignments) {
      totalPoints += assignment.task.rewardPoints;
    }
    return totalPoints;
  }

  async createTaskAssignment({
    workspaceUserId,
    taskId,
    status,
  }: {
    workspaceUserId: TaskAssignment['assignee']['id'];
    taskId: TaskAssignment['task']['id'];
    status: TaskAssignment['status'];
  }): Promise<TaskAssignmentCore> {
    const newTaskAssignment = await this.taskAssignmentRepository.create({
      workspaceUserId,
      taskId,
      status,
    });

    if (!newTaskAssignment) {
      throw new InternalServerErrorException();
    }

    return newTaskAssignment;
  }
}
