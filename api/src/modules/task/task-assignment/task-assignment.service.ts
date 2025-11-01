import { HttpStatus, Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { UpdateTaskAssignmentsRequest } from 'src/modules/workspace/workspace-module/dto/request/update-task-assignment-request.dto';
import { ProgressStatus } from '../task-module/domain/progress-status.enum';
import { TaskAssignmentCore } from './domain/task-assignment-core.domain';
import { TaskAssignmentWithAssigneeUser } from './domain/task-assignment-with-assignee-user.domain';
import { TaskAssignment } from './domain/task-assignment.domain';
import { TaskAssignmentRepository } from './persistence/task-assignment.repository';

@Injectable()
export class TaskAssignmentService {
  constructor(
    private readonly taskAssignmentRepository: TaskAssignmentRepository,
    private readonly unitOfWorkService: UnitOfWorkService,
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
  }): Promise<TaskAssignmentWithAssigneeUser> {
    const newTaskAssignment = await this.taskAssignmentRepository.create({
      workspaceUserId,
      taskId,
      status,
      relations: {
        assignee: {
          user: true,
        },
      },
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

  async findByTaskId(
    taskId: TaskAssignment['task']['id'],
  ): Promise<Nullable<TaskAssignmentCore>> {
    return await this.taskAssignmentRepository.findByTaskId({
      id: taskId,
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

  async updateAssignmentsByTaskId({
    taskId,
    data,
  }: {
    taskId: TaskAssignment['task']['id'];
    workspaceId: TaskAssignment['task']['workspace']['id'];
    data: UpdateTaskAssignmentsRequest['assignments'];
  }): Promise<TaskAssignmentWithAssigneeUser[]> {
    // 1. Get task assignments
    const taskAssignments = await this.findAllByTaskIdWithAssigneeUser(taskId);

    if (taskAssignments.length === 0) {
      // If there are no assignments, return empty array
      return [];
    }

    // 2. Update existing task assignments statuses
    await this.unitOfWorkService.withTransaction(async () => {
      for (const assignment of data) {
        const existingAssignment = taskAssignments.find(
          (existingAssignment) =>
            existingAssignment.assignee.id === assignment.assigneeId,
        );
        const isNewStatus =
          existingAssignment && assignment.status !== existingAssignment.status;

        if (existingAssignment && isNewStatus) {
          await this.taskAssignmentRepository.update({
            id: existingAssignment.id,
            data: { status: assignment.status },
          });
        }
      }
    });

    return this.findAllByTaskIdWithAssigneeUser(taskId);
  }

  async deleteByTaskIdAndAssigneeId({
    assigneeId,
    taskId,
  }: {
    assigneeId: TaskAssignment['assignee']['id'];
    taskId: TaskAssignment['task']['id'];
  }): Promise<void> {
    this.taskAssignmentRepository.deleteByTaskIdAndAssigneeIds({
      taskId,
      assigneeIds: [assigneeId],
    });
  }
}
