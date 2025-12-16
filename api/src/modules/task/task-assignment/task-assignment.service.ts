import { HttpStatus, Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { UpdateTaskAssignmentsRequest } from 'src/modules/workspace/workspace-module/dto/request/update-task-assignment-request.dto';
import { ProgressStatus } from '../task-module/domain/progress-status.enum';
import { TASK_MAXIMUM_ASSIGNEES_COUNT } from '../task-module/domain/task.constants';
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
          // COMPLETED_AS_STALE won't fall into accumulated points
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

  async createMultiple({
    workspaceUserIds,
    taskId,
    status,
  }: {
    workspaceUserIds: Array<TaskAssignment['assignee']['id']>;
    taskId: TaskAssignment['task']['id'];
    status: TaskAssignment['status'];
  }): Promise<Array<TaskAssignmentCore>> {
    // Check if there already are 10 assignees assigned (= 10 assignments)
    const taskAssignments = await this.findAllByTaskId(taskId);

    if (taskAssignments.length === TASK_MAXIMUM_ASSIGNEES_COUNT) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.TASK_ASSIGNEES_COUNT_MAXED_OUT,
        },
        HttpStatus.UNPROCESSABLE_ENTITY,
      );
    }

    // Check if any of the provided assignee IDs already exists as assignment
    const existingTaskAssignments = await this.findAllByTaskIdAndAssigneeIds({
      taskId,
      assigneeIds: workspaceUserIds,
    });

    if (existingTaskAssignments.length > 0) {
      // One or more provided assignee IDs already exist in task assignments for the given task
      throw new ApiHttpException(
        {
          code: ApiErrorCode.TASK_ASSIGNEES_ALREADY_EXIST,
        },
        HttpStatus.UNPROCESSABLE_ENTITY,
      );
    }

    const newTaskAssignments =
      await this.taskAssignmentRepository.createMultiple({
        workspaceUserIds,
        taskId,
        status,
      });

    // Maybe also somehow detect that unique constraint on the
    // entity has triggered because someone tried to add a
    // assignee which was already assigned?

    if (newTaskAssignments.length !== workspaceUserIds.length) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return newTaskAssignments;
  }

  async findByIdWithAssigneeUser(
    taskAssignmentId: TaskAssignment['id'],
  ): Promise<Nullable<TaskAssignmentCore>> {
    return await this.taskAssignmentRepository.findByIdWithAssigneeUser({
      id: taskAssignmentId,
      relations: {
        assignee: {
          user: true,
        },
      },
    });
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

  async findAllByTaskId(
    taskId: TaskAssignment['task']['id'],
  ): Promise<TaskAssignmentCore[]> {
    return await this.taskAssignmentRepository.findAllByTaskId({
      taskId,
    });
  }

  async findAllByTaskIdAndAssigneeIds({
    taskId,
    assigneeIds,
  }: {
    taskId: TaskAssignment['task']['id'];
    assigneeIds: Array<TaskAssignment['assignee']['id']>;
  }): Promise<TaskAssignmentCore[]> {
    return await this.taskAssignmentRepository.findAllByTaskIdAndAssigneeId({
      taskId,
      assigneeIds,
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

  /**
   * This is idempotent solution because it uses Typeorm's
   * delete funtion, which doesn't check if the record actually
   * exists. This is actually a good solution for the case
   * when a Manager2 tries to remove a assignee which was already
   * removed by Manager1 (Manager2 had stale tasks response). In
   * that case, 204 status will be sent to Manager2 (even though
   * there was no actual deletion) and frontend will then manually
   * remove that assignee from the tasks cache.
   */
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

  async closeAssignmentsByTaskId(taskId: string): Promise<void> {
    // Not using TaskService class to check taskId validity here
    // because I don't want this class to depend on that service.
    // Furthermore, a task must have a minimum of 1 assignee, so
    // checking here if there are no assignments by the provided
    // taskId is enough.
    const assignments = await this.findAllByTaskId(taskId);

    if (assignments.length === 0) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.UNPROCESSABLE_ENTITY,
      );
    }

    await this.unitOfWorkService.withTransaction(async () => {
      for (const assignment of assignments) {
        await this.taskAssignmentRepository.update({
          id: assignment.id,
          data: { status: ProgressStatus.CLOSED },
        });
      }
    });
  }
}
