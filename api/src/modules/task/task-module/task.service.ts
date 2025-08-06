import { HttpStatus, Injectable } from '@nestjs/common';
import { DateTime } from 'luxon';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { CreateTaskRequest } from 'src/modules/workspace/workspace-module/dto/request/create-task-request.dto';
import { UpdateTaskRequest } from 'src/modules/workspace/workspace-module/dto/request/update-task-request.dto';
import { WorkspaceObjectiveRequestQuery } from 'src/modules/workspace/workspace-module/dto/request/workspace-item-request.dto';
import { TaskCore } from './domain/task-core.domain';
import { TaskWithAssigneesCore } from './domain/task-with-assignees-core.domain';
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
    data: TaskWithAssigneesCore[];
    totalPages: number;
    total: number;
  }> {
    const {
      data: taskEntities,
      totalPages,
      total,
    } = await this.taskRepository.findAllByWorkspaceId({
      workspaceId,
      query,
    });

    const tasks: TaskWithAssigneesCore[] = taskEntities.map((task) => ({
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
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      deletedAt: task.deletedAt,
    }));

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
  }): Promise<TaskCore> {
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
    });

    if (!newTask) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return newTask;
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
  }): Promise<TaskWithAssigneesCore> {
    const task = await this.findByTaskIdAndWorkspaceId({ taskId, workspaceId });

    if (!task) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    let dueDate: Date | undefined;
    if (data.dueDate !== null && data.dueDate !== undefined) {
      dueDate = DateTime.fromISO(data.dueDate).toUTC().toJSDate();
    }
    console.log(data.title);
    console.log(data.description);
    console.log(data.rewardPoints);
    console.log(dueDate);

    const updatedTask = await this.taskRepository.update({
      id: taskId,
      data: {
        title: data.title,
        description: data.description,
        rewardPoints: data.rewardPoints,
        dueDate: dueDate,
      },
      relations: {
        taskAssignments: {
          assignee: {
            user: true,
          },
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
    };
  }
}
