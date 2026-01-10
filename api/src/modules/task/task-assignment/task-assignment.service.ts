import { HttpStatus, Injectable } from '@nestjs/common';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { UpdateTaskAssignmentsRequest } from 'src/modules/workspace/workspace-module/dto/request/update-task-assignment-request.dto';
import { ProgressStatus } from '../task-module/domain/progress-status.enum';
import { TASK_MAXIMUM_ASSIGNEES_COUNT } from '../task-module/domain/task.constants';
import { TaskAssignmentCore } from './domain/task-assignment-core.domain';
import { TaskAssignmentWithAssigneeUser } from './domain/task-assignment-with-assignee-user.domain';
import { TaskAssignmentWithAssignee } from './domain/task-assignment-with-assignee.domain';
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
    // Initial implementation was finding all Completed assignments
    // of the given user in the given workspace. This is not good
    // because we could read a large number of objects into RAM
    // this way and kill the server.
    return this.taskAssignmentRepository.sumPointsByAssignee({
      workspaceId,
      workspaceUserId,
    });
  }

  async createMultiple({
    assignments,
    taskId,
  }: {
    assignments: Array<{
      workspaceUserId: TaskAssignment['assignee']['id'];
      status: TaskAssignment['status'];
    }>;
    taskId: TaskAssignment['task']['id'];
  }): Promise<Array<TaskAssignmentWithAssigneeUser>> {
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

    const workspaceUserIds = assignments.map(
      (assignment) => assignment.workspaceUserId,
    );

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
        assignments,
        taskId,
        relations: {
          assignee: {
            user: true,
          },
        },
      });

    if (newTaskAssignments.length !== assignments.length) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return newTaskAssignments;
  }

  findAllByTaskIdWithAssigneeUser(
    taskId: TaskAssignment['task']['id'],
  ): Promise<TaskAssignmentWithAssigneeUser[]> {
    return this.taskAssignmentRepository.findAllByTaskId({
      taskId,
      relations: {
        assignee: {
          user: true,
        },
      },
    });
  }

  findAllByTaskId(
    taskId: TaskAssignment['task']['id'],
  ): Promise<TaskAssignmentCore[]> {
    return this.taskAssignmentRepository.findAllByTaskId({
      taskId,
    });
  }

  findAllByTaskIdAndAssigneeIds({
    taskId,
    assigneeIds,
  }: {
    taskId: TaskAssignment['task']['id'];
    assigneeIds: Array<TaskAssignment['assignee']['id']>;
  }): Promise<TaskAssignmentCore[]> {
    return this.taskAssignmentRepository.findAllByTaskIdAndAssigneeId({
      taskId,
      assigneeIds,
    });
  }

  findAllByTaskIdAndAssigneeIdsWithAssignee({
    taskId,
    assigneeIds,
  }: {
    taskId: TaskAssignment['task']['id'];
    assigneeIds: Array<TaskAssignment['assignee']['id']>;
  }): Promise<TaskAssignmentWithAssignee[]> {
    return this.taskAssignmentRepository.findAllByTaskIdAndAssigneeId({
      taskId,
      assigneeIds,
      relations: {
        assignee: true,
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
    await this.unitOfWorkService.withTransaction(async () => {
      // We need to check if provided assignee IDs exist as this specific
      // task assignments. Possible case is another Manager removed one or
      // more of these workspace users. Also, we do this in the transaction
      // for race condition edge cases.
      const providedAssigneeIds = data.map((item) => item.assigneeId);
      const existingTaskAssignments =
        await this.findAllByTaskIdAndAssigneeIdsWithAssignee({
          taskId,
          assigneeIds: providedAssigneeIds,
        });

      if (existingTaskAssignments.length !== providedAssigneeIds.length) {
        // One or more provided assignee IDs doesn't exist in task assignments for the given task
        throw new ApiHttpException(
          {
            code: ApiErrorCode.TASK_ASSIGNEES_INVALID,
          },
          HttpStatus.UNPROCESSABLE_ENTITY,
        );
      }

      for (const assignment of data) {
        const existingAssignment = existingTaskAssignments.find(
          (existingAssignment) =>
            existingAssignment.assignee.id === assignment.assigneeId,
        );
        const isNewStatus =
          existingAssignment && assignment.status !== existingAssignment.status;

        if (existingAssignment && isNewStatus) {
          const updatedTaskAssignment =
            await this.taskAssignmentRepository.update({
              id: existingAssignment.id,
              data: { status: assignment.status },
            });

          if (!updatedTaskAssignment) {
            // Another Manager deleted this assignment
            // in the meantime.
            // Not possible as there is no way for the
            // user to delete assignments.
            throw new ApiHttpException(
              {
                code: ApiErrorCode.INVALID_PAYLOAD,
              },
              HttpStatus.NOT_FOUND,
            );
          }
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
    await this.taskAssignmentRepository.deleteByTaskIdAndAssigneeIds({
      taskId,
      assigneeIds: [assigneeId],
    });
  }

  // Idempotent solution
  async closeAssignmentsByTaskId(taskId: string): Promise<void> {
    // Initial implementation was finding all assignments by taskId
    // in the given workspace and then doing update query for each
    // assignment. This is not optimal. Better solution is to do
    // one larger query update by taskId.
    const assignmentsCount =
      await this.taskAssignmentRepository.countByTaskId(taskId);

    if (assignmentsCount === 0) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    await this.unitOfWorkService.withTransaction(async () => {
      const updatedTaskAssignments =
        await this.taskAssignmentRepository.updateAllByTaskId({
          taskId,
          data: { status: ProgressStatus.CLOSED },
        });

      if (
        !updatedTaskAssignments ||
        updatedTaskAssignments.length != assignmentsCount
      ) {
        // Another Manager deleted this assignment
        // in the meantime.
        // Not possible as there is no way for the
        // user to delete assignments.
        throw new ApiHttpException(
          {
            code: ApiErrorCode.INVALID_PAYLOAD,
          },
          HttpStatus.NOT_FOUND,
        );
      }
    });
  }
}
