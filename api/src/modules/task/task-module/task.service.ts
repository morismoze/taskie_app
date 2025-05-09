import { Injectable } from '@nestjs/common';
import { CreateTaskRequest } from 'src/modules/workspace/workspace-module/dto/create-task-request.dto';
import { WorkspaceItemRequestQuery } from 'src/modules/workspace/workspace-module/dto/workspace-item-request.dto';
import { TaskCore } from './domain/task-core.domain';
import { TaskWithAssignees } from './domain/task-with-assignees.domain';
import { Task } from './domain/task.domain';
import { TaskRepository } from './persistence/task.repository';

@Injectable()
export class TaskService {
  constructor(private readonly taskRepository: TaskRepository) {}

  async getTasksByWorkspaceWithAssignees({
    workspaceId,
    query,
  }: {
    workspaceId: string;
    query: WorkspaceItemRequestQuery;
  }): Promise<{
    data: TaskWithAssignees[];
    total: number;
  }> {
    const { data: taskEntities, total } =
      await this.taskRepository.findAllByWorkspaceId({
        workspaceId,
        query,
        relations: {
          taskAssignments: {
            assignee: true,
          },
        },
      });

    const tasks: TaskWithAssignees[] = taskEntities.map((task) => ({
      id: task.id,
      title: task.title,
      rewardPoints: task.rewardPoints,
      description: task.description,
      dueDate: task.dueDate,
      assignees: task.taskAssignments.map((assignment) => ({
        id: assignment.assignee.user.id,
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
      total: total,
    };
  }

  async createTask({
    workspaceId,
    data,
  }: {
    workspaceId: Task['workspace']['id'];
    data: CreateTaskRequest;
  }): Promise<TaskCore> {}
}
