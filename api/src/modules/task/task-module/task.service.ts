import { Injectable } from '@nestjs/common';
import { WorkspaceTasksRequestQuery } from 'src/modules/workspace/workspace-module/dto/workspace-tasks-request.dto';
import { TaskAssignment } from '../task-assignment/domain/task-assignment.domain';
import { ProgressStatus } from './domain/progress-status.enum';
import { Task } from './domain/task.domain';
import { TaskRepository } from './persistence/task.repository';

@Injectable()
export class TaskService {
  constructor(private readonly taskRepository: TaskRepository) {}

  async getWorkspaceTasks({
    workspaceId,
    query,
  }: {
    workspaceId: string;
    query: WorkspaceTasksRequestQuery;
  }): Promise<{
    data: {
      id: Task['id'];
      title: Task['title'];
      rewardPoints: Task['rewardPoints'];
      assignees: {
        id: TaskAssignment['assignee']['user']['id'];
        firstName: TaskAssignment['assignee']['user']['firstName'];
        lastName: TaskAssignment['assignee']['user']['lastName'];
        profileImageUrl: TaskAssignment['assignee']['user']['profileImageUrl'];
        status: ProgressStatus;
      }[];
    }[];
    total: number;
  }> {
    const { data: taskEntities, total } =
      await this.taskRepository.findTasksWithAssigneesForWorkspace(
        workspaceId,
        query,
      );

    const workspaceTasks = taskEntities.map((task) => ({
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
    }));

    return {
      data: workspaceTasks,
      total: total,
    };
  }
}
