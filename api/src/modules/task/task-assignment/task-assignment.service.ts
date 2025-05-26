import { HttpStatus, Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/ApiHttpException.type';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { UpdateTaskAssignmentsStatusesRequest } from 'src/modules/workspace/workspace-module/dto/request/update-task-assignments-statuses-request.dto';
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

  async updateAssignessByTaskId({
    taskId,
    data,
  }: {
    taskId: TaskAssignment['task']['id'];
    data: UpdateTaskAssignmentsStatusesRequest;
  }): Promise<TaskAssignmentWithAssigneeUser[]> {
    const taskAssignments = await this.findAllByTaskIdWithAssigneeUser(taskId);

    const existingAssigneeIds = taskAssignments.map(
      (taskAssignment) => taskAssignment.assignee.id,
    );
    const updatedAssigneeIds = data.map((data) => data.assigneeId);
    const assigneeIdsToRemove = existingAssigneeIds.filter(
      (existingAssigneeId) => !updatedAssigneeIds.includes(existingAssigneeId),
    );
    const assigneeIdsToAdd = updatedAssigneeIds.filter(
      (existingAssigneeId) => !existingAssigneeIds.includes(existingAssigneeId),
    );

    await this.unitOfWorkService.withTransaction(() => {
      // 1. Delete task assignments if some assignees were removed from the task
      this.taskAssignmentRepository.deleteByTaskIdAndAssigneeIds({
        taskId,
        assigneeIds: assigneeIdsToRemove,
      });

      // 2. Create new task assignments if there are new assignees
      for (const assigneeId of assigneeIdsToAdd) {
        this.create({
          workspaceUserId: assigneeId,
          taskId,
          status: ProgressStatus.IN_PROGRESS,
        });
      }
    });

    return this.findAllByTaskIdWithAssigneeUser(taskId);
  }
}
