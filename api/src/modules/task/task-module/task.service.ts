import { Injectable } from '@nestjs/common';
import { WorkspaceTasksRequestQuery } from 'src/modules/workspace/workspace-module/dto/workspace-tasks-request.dto';
import { TaskWithAssignees } from './domain/task-with-assignees.domain';
import { TaskRepository } from './persistence/task.repository';

@Injectable()
export class TaskService {
  constructor(private readonly taskRepository: TaskRepository) {}

  async getTasksByWorkspaceWithAssignees({
    workspaceId,
    query,
  }: {
    workspaceId: string;
    query: WorkspaceTasksRequestQuery;
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
      assignees: task.taskAssignments.map((assignment) => ({
        id: assignment.assignee.user.id,
        firstName: assignment.assignee.user.firstName,
        lastName: assignment.assignee.user.lastName,
        profileImageUrl: assignment.assignee.user.profileImageUrl,
        status: assignment.status,
      })),
      createdAt: task.createdAt,
      deletedAt: task.deletedAt,
      description: task.description,
      dueDate: task.dueDate,
    }));

    return {
      data: tasks,
      total: total,
    };
  }
}
