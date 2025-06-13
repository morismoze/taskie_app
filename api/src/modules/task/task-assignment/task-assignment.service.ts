import { HttpStatus, Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/ApiHttpException.type';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { UpdateTaskAssignmentsRequest } from 'src/modules/workspace/workspace-module/dto/request/update-task-assignment-status-request.dto';
import { ProgressStatus } from '../task-module/domain/progress-status.enum';
import { TaskService } from '../task-module/task.service';
import { TaskAssignmentCore } from './domain/task-assignment-core.domain';
import { TaskAssignmentWithAssigneeUser } from './domain/task-assignment-with-assignee-user.domain';
import { TaskAssignment } from './domain/task-assignment.domain';
import { TaskAssignmentRepository } from './persistence/task-assignment.repository';

@Injectable()
export class TaskAssignmentService {
  constructor(
    private readonly taskAssignmentRepository: TaskAssignmentRepository,
    private readonly unitOfWorkService: UnitOfWorkService,
    private readonly taskService: TaskService,
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
    workspaceId,
    data,
  }: {
    taskId: TaskAssignment['task']['id'];
    workspaceId: TaskAssignment['task']['workspace']['id'];
    data: UpdateTaskAssignmentsRequest['assignments'];
  }): Promise<TaskAssignmentWithAssigneeUser[]> {
    // 1. Check that the given task exists in the given workspace
    const task = await this.taskService.findByTaskIdAndWorkspaceId({
      taskId,
      workspaceId,
    });

    if (!task) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    // 2. Get task assignments
    const taskAssignments = await this.findAllByTaskIdWithAssigneeUser(taskId);

    if (taskAssignments.length === 0) {
      // If there are no assignments, return empty array
      return [];
    }

    const existingAssigneeMap = new Map(
      taskAssignments.map((taskAssignment) => [
        taskAssignment.assignee.id,
        taskAssignment,
      ]),
    );
    const updatedAssigneeMap = new Map(
      data.map((item) => [item.assigneeId, item]),
    );

    const assigneeIdsToUpdate = Array.from(existingAssigneeMap.keys()).filter(
      (id) => updatedAssigneeMap.has(id),
    );
    const assigneeIdsToRemove = Array.from(existingAssigneeMap.keys()).filter(
      (existingAssigneeId) => !updatedAssigneeMap.has(existingAssigneeId),
    );
    const assigneeIdsToAdd = Array.from(updatedAssigneeMap.keys()).filter(
      (updatedAssigneeId) => !existingAssigneeMap.has(updatedAssigneeId),
    );

    await this.unitOfWorkService.withTransaction(async () => {
      // 1. Delete task assignments if some assignees were removed from the task
      if (assigneeIdsToRemove.length > 0) {
        await this.taskAssignmentRepository.deleteByTaskIdAndAssigneeIds({
          taskId,
          assigneeIds: assigneeIdsToRemove,
        });
      }

      // 2. Create new task assignments if there are new assignees
      for (const assigneeId of assigneeIdsToAdd) {
        await this.create({
          workspaceUserId: assigneeId,
          taskId,
          status: ProgressStatus.IN_PROGRESS,
        });
      }

      // 3. Update existing task assignments statuses if needed
      for (const assigneeId of assigneeIdsToUpdate) {
        const existingAssignment = existingAssigneeMap.get(assigneeId);
        const newStatus = updatedAssigneeMap.get(assigneeId)!.status;

        if (
          existingAssignment &&
          newStatus &&
          existingAssignment.status !== newStatus
        ) {
          await this.taskAssignmentRepository.update({
            id: existingAssignment.id,
            data: { status: newStatus },
          });
        }
      }
    });

    return this.findAllByTaskIdWithAssigneeUser(taskId);
  }
}
