import { HttpStatus, Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/ApiHttpException.type';
import { ProgressStatus } from '../task-module/domain/progress-status.enum';
import { TaskAssignmentCore } from './domain/task-assignment-core.domain';
import { TaskAssignmentWithAssigneeCoreAndTaskCore } from './domain/task-assignment-with-assignee-core-and-task-core.domain';
import { TaskAssignmentWithAssigneeUser } from './domain/task-assignment-with-assignee-user.domain';
import { TaskAssignment } from './domain/task-assignment.domain';
import { TaskAssignmentRepository } from './persistence/task-assignment.repository';

@Injectable()
export class TaskAssignmentService {
  constructor(
    private readonly taskAssignmentRepository: TaskAssignmentRepository,
  ) {}

  async getAccumulatedPointsForWorkspaceUser({
    workspaceId,
    workspaceUserId,
  }: {
    workspaceId: string;
    workspaceUserId: string;
  }): Promise<number> {
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

  async create({
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
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return newTaskAssignment;
  }

  async findByTaskIdAndAssigneeId({
    taskId,
    assigneeId,
  }: {
    taskId: TaskAssignment['task']['id'];
    assigneeId: TaskAssignment['assignee']['id'];
  }): Promise<Nullable<TaskAssignmentCore>> {
    return await this.taskAssignmentRepository.findByTaskIdAndAssigneeId({
      taskId,
      assigneeId,
    });
  }

  async findAllByTaskIdWithAssigneeUser(
    taskId: TaskAssignment['task']['id'],
  ): Promise<TaskAssignmentWithAssigneeUser[]> {
    return await this.taskAssignmentRepository.findAllByTaskId({
      taskId,
      relations: {
        assignee: {
          user: true,
        },
      },
    });
  }

  async updateByTaskIdAndAssigneeId({
    assigneeId,
    taskId,
    status,
  }: {
    assigneeId: TaskAssignment['assignee']['id'];
    taskId: TaskAssignment['task']['id'];
    status: TaskAssignment['status'];
  }): Promise<TaskAssignmentWithAssigneeCoreAndTaskCore> {
    const taskAssignment = await this.findByTaskIdAndAssigneeId({
      taskId,
      assigneeId,
    });

    if (!taskAssignment) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const updatedTaskAssignment = await this.taskAssignmentRepository.update({
      id: taskAssignment.id,
      data: {
        status,
      },
      relations: {
        assignee: true,
        task: true,
      },
    });

    if (!updatedTaskAssignment) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return updatedTaskAssignment;
  }
}
