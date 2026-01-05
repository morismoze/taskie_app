import { HttpStatus, Injectable } from '@nestjs/common';
import { DateTime } from 'luxon';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { CreateTaskRequest } from 'src/modules/workspace/workspace-module/dto/request/create-task-request.dto';
import { UpdateTaskRequest } from 'src/modules/workspace/workspace-module/dto/request/update-task-request.dto';
import {
  SortBy,
  WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT,
  WorkspaceObjectiveRequestQuery,
} from 'src/modules/workspace/workspace-module/dto/request/workspace-objective-request-query.dto';
import { TaskCore } from './domain/task-core.domain';
import { TaskWithAssigneesCoreAndCreatedByUser } from './domain/task-with-assignees-core.domain';
import { Task } from './domain/task.domain';
import { TaskRepository } from './persistence/task.repository';

@Injectable()
export class TaskService {
  constructor(private readonly taskRepository: TaskRepository) {}

  async findPaginatedByWorkspaceWithAssignees({
    workspaceId,
    query,
  }: {
    workspaceId: Task['workspace']['id'];
    query: WorkspaceObjectiveRequestQuery;
  }): Promise<{
    data: TaskWithAssigneesCoreAndCreatedByUser[];
    totalPages: number;
    total: number;
  }> {
    const effectiveQuery = {
      page: query.page ?? 1,
      limit: query.limit ?? WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT,
      status: query.status ?? null,
      search: query.search?.trim() || null,
      sort: query.sort ?? SortBy.NEWEST,
    };
    const {
      data: taskEntities,
      totalPages,
      total,
    } = await this.taskRepository.findAllByWorkspaceId({
      workspaceId,
      query: effectiveQuery,
    });

    const tasks: TaskWithAssigneesCoreAndCreatedByUser[] = taskEntities.map(
      (task) => ({
        id: task.id,
        title: task.title,
        rewardPoints: task.rewardPoints,
        description: task.description,
        dueDate: task.dueDate,
        assignees: task.taskAssignments.map((assignment) => ({
          id: assignment.assignee.id, // workspace user ID
          firstName: assignment.assignee.user.firstName,
          lastName: assignment.assignee.user.lastName,
          profileImageUrl: assignment.assignee.user.profileImageUrl,
          status: assignment.status,
        })),
        createdBy:
          task.createdBy === null
            ? null
            : {
                id: task.createdBy.id,
                firstName: task.createdBy.user.firstName,
                lastName: task.createdBy.user.lastName,
                profileImageUrl: task.createdBy.user.profileImageUrl,
              },
        createdAt: task.createdAt,
        updatedAt: task.updatedAt,
        deletedAt: task.deletedAt,
      }),
    );

    return {
      data: tasks,
      totalPages,
      total,
    };
  }

  async create({
    workspaceId,
    createdById,
    data,
  }: {
    workspaceId: Task['workspace']['id'];
    createdById: Task['createdBy']['id'];
    // Assignees are used for task assignment records
    // This is just creation of a concrete task
    data: Omit<CreateTaskRequest, 'assignees'>;
  }): Promise<TaskWithAssigneesCoreAndCreatedByUser> {
    const newTask = await this.taskRepository.create({
      workspaceId,
      data: {
        title: data.title,
        description: data.description,
        rewardPoints: data.rewardPoints,
        dueDate:
          data.dueDate === null
            ? null
            : DateTime.fromISO(data.dueDate).toJSDate(),
      },
      createdById,
      relations: {
        createdBy: {
          user: true,
        },
      },
    });

    if (!newTask) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return {
      ...newTask,
      assignees: [],
      createdBy:
        newTask.createdBy === null
          ? null
          : {
              id: newTask.createdBy.id,
              firstName: newTask.createdBy.user.firstName,
              lastName: newTask.createdBy.user.lastName,
              profileImageUrl: newTask.createdBy.user.profileImageUrl,
            },
    };
  }

  async findById(id: Task['id']): Promise<Nullable<TaskCore>> {
    return await this.taskRepository.findById({
      id,
    });
  }

  async findByTaskIdAndWorkspaceId({
    taskId,
    workspaceId,
  }: {
    taskId: Task['id'];
    workspaceId: Task['workspace']['id'];
  }): Promise<Nullable<TaskCore>> {
    return await this.taskRepository.findByTaskIdAndWorkspaceId({
      taskId,
      workspaceId,
    });
  }

  async updateByTaskIdAndWorkspaceId({
    taskId,
    workspaceId,
    data,
  }: {
    taskId: Task['id'];
    workspaceId: Task['workspace']['id'];
    data: UpdateTaskRequest;
  }): Promise<TaskWithAssigneesCoreAndCreatedByUser> {
    const task = await this.findByTaskIdAndWorkspaceId({ taskId, workspaceId });

    if (!task) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const updatedTask = await this.taskRepository.update({
      id: taskId,
      data: {
        title: data.title,
        description: data.description,
        rewardPoints: data.rewardPoints,
        dueDate:
          data.dueDate !== null && data.dueDate !== undefined
            ? DateTime.fromISO(data.dueDate).toUTC().toJSDate()
            : data.dueDate,
      },
      relations: {
        taskAssignments: {
          assignee: {
            user: true,
          },
        },
        createdBy: {
          user: true,
        },
      },
    });

    if (!updatedTask) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return {
      ...updatedTask,
      assignees: updatedTask.taskAssignments.map((assignment) => ({
        id: assignment.assignee.id, // workspace user ID
        firstName: assignment.assignee.user.firstName,
        lastName: assignment.assignee.user.lastName,
        profileImageUrl: assignment.assignee.user.profileImageUrl,
        status: assignment.status,
      })),
      createdBy:
        updatedTask.createdBy === null
          ? null
          : {
              id: updatedTask.createdBy.id,
              firstName: updatedTask.createdBy.user.firstName,
              lastName: updatedTask.createdBy.user.lastName,
              profileImageUrl: updatedTask.createdBy.user.profileImageUrl,
            },
    };
  }
}
