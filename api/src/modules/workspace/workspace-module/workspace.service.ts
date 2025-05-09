import {
  ForbiddenException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { JwtPayload } from 'src/modules/auth/core/strategies/domain/jwt-payload.domain';
import { GoalService } from 'src/modules/goal/goal.service';
import { TaskService } from 'src/modules/task/task-module/task.service';
import { UserService } from 'src/modules/user/user.service';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from '../workspace-user-module/domain/workspace-user-status.enum';
import { WorkspaceUser } from '../workspace-user-module/domain/workspace-user.domain';
import { WorkspaceUserService } from '../workspace-user-module/workspace-user.service';
import { Workspace } from './domain/workspace.domain';
import { CreateVirtualWorkspaceUserRequest } from './dto/create-virtual-workspace-user-request.dto';
import { CreateWorkspaceRequest } from './dto/create-workspace-request.dto';
import {
  WorkspaceUserResponse,
  WorkspaceUsersResponse,
} from './dto/workspace-members-response.dto';
import { WorkspaceItemRequestQuery } from './dto/workspace-item-request.dto';
import { WorkspaceTasksResponse } from './dto/workspace-tasks-response.dto';
import {
  WorkspaceResponse,
  WorkspacesResponse,
} from './dto/workspaces-response.dto';
import { WorkspaceRepository } from './persistence/workspace.repository';
import { WorkspaceGoalsResponse } from './dto/workspace-goals-response.dto';
import { CreateTaskRequest } from './dto/create-task-request.dto';
import { TaskAssignmentService } from 'src/modules/task/task-assignment/task-assignment.service';

@Injectable()
export class WorkspaceService {
  constructor(
    private readonly workspaceRepository: WorkspaceRepository,
    private readonly workspaceUserService: WorkspaceUserService,
    private readonly userService: UserService,
    private readonly taskService: TaskService,
    private readonly goalService: GoalService,
    private readonly taskAssignmentService: TaskAssignmentService,
  ) {}

  async create({
    data,
    createdById,
  }: {
    createdById: Workspace['createdBy']['id'];
    data: CreateWorkspaceRequest;
  }): Promise<WorkspaceResponse> {
    const ownerUser = await this.userService.findById(createdById);

    if (!ownerUser) {
      // Corrupted access token
      throw new ForbiddenException();
    }

    // 1. create a new empty workspace
    const newWorkspace = await this.workspaceRepository.create({
      data: {
        createdById: ownerUser.id,
        description: data.description,
        name: data.name,
        pictureUrl: null,
      },
    });

    if (!newWorkspace) {
      throw new InternalServerErrorException();
    }

    // 2. create a new workspace user for the owner
    await this.workspaceUserService.create({
      workspaceId: newWorkspace.id,
      userId: ownerUser.id,
      workspaceRole: WorkspaceUserRole.MANAGER,
      status: WorkspaceUserStatus.ACTIVE,
    });

    const response: WorkspaceResponse = {
      id: newWorkspace.id,
      name: newWorkspace.name,
      description: newWorkspace.description,
      pictureUrl: newWorkspace.pictureUrl,
    };

    return response;
  }

  async createVirtualUser({
    workspaceId,
    createdById,
    data,
  }: {
    workspaceId: Workspace['id'];
    createdById: JwtPayload['userId'];
    data: CreateVirtualWorkspaceUserRequest;
  }): Promise<WorkspaceUserResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
      relations: {
        members: {
          user: true,
        },
      },
    });

    if (!workspace) {
      throw new NotFoundException();
    }

    const creatorWorkspaceUser =
      await this.workspaceUserService.findByUserId(createdById);

    if (!creatorWorkspaceUser) {
      throw new NotFoundException();
    }

    // 1. Create core user
    const newUser = await this.userService.createVirtualUser(data);

    // 2. Create a workspace user relation linking the user to the workspace
    const newWorkspaceUser = await this.workspaceUserService.createVirtualUser({
      workspaceId: workspace.id,
      userId: newUser.id,
      createdById: creatorWorkspaceUser.id,
    });

    const response: WorkspaceUserResponse = {
      id: newWorkspaceUser.id,
      firstName: newUser.firstName,
      lastName: newUser.lastName,
      // Currently uploading images while creating virtual users is not supported
      profileImageUrl: null,
    };

    return response;
  }

  async getWorkspacesByUser(
    userId: WorkspaceUser['user']['id'],
  ): Promise<WorkspacesResponse> {
    const userWorkspaces = await this.workspaceRepository.findAllByUserId({
      userId,
    });
    const response: WorkspacesResponse = userWorkspaces.map((workspace) => ({
      id: workspace.id,
      name: workspace.name,
      description: workspace.description,
      pictureUrl: workspace.pictureUrl,
    }));

    return response;
  }

  async getWorkspaceMembers(
    workspaceId: Workspace['id'],
  ): Promise<WorkspaceUsersResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
      relations: {
        members: { user: true },
      },
    });

    if (!workspace) {
      throw new NotFoundException();
    }

    const response: WorkspaceUsersResponse = workspace.members.map(
      (member) => ({
        id: member.id,
        firstName: member.user.firstName,
        lastName: member.user.lastName,
        profileImageUrl: member.user.profileImageUrl,
      }),
    );

    return response;
  }

  async getWorkspaceTasks({
    workspaceId,
    query,
  }: {
    workspaceId: Workspace['id'];
    query: WorkspaceItemRequestQuery;
  }): Promise<WorkspaceTasksResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
    });

    if (!workspace) {
      throw new NotFoundException();
    }

    const { data: tasks, total } =
      await this.taskService.getTasksByWorkspaceWithAssignees({
        workspaceId,
        query,
      });

    const response: WorkspaceTasksResponse = {
      data: tasks.map((task) => ({
        id: task.id,
        title: task.title,
        rewardPoints: task.rewardPoints,
        assignees: task.assignees.map((assignee) => ({
          id: assignee.id,
          firstName: assignee.firstName,
          lastName: assignee.lastName,
          profileImageUrl: assignee.profileImageUrl,
          status: assignee.status,
        })),
      })),
      total,
    };

    return response;
  }

  async getWorkspaceGoals({
    workspaceId,
    query,
  }: {
    workspaceId: Workspace['id'];
    query: WorkspaceItemRequestQuery;
  }): Promise<WorkspaceGoalsResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
    });

    if (!workspace) {
      throw new NotFoundException();
    }

    const { data: goals, total } = await this.goalService.getGoalsByWorkspace({
      workspaceId,
      query,
    });

    const response: WorkspaceGoalsResponse = {
      data: goals.map((goal) => ({
        id: goal.id,
        assignee: {
          id: goal.assignee.id,
          firstName: goal.assignee.firstName,
          lastName: goal.assignee.lastName,
          profileImageUrl: goal.assignee.profileImageUrl,
        },
        title: goal.title,
        requiredPoints: goal.requiredPoints,
        status: goal.status,
      })),
      total,
    };

    return response;
  }

  async createTask({
    workspaceId,
    data,
  }: {
    workspaceId: Workspace['id'];
    data: CreateTaskRequest;
  }): Promise<void> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
    });

    if (!workspace) {
      throw new NotFoundException();
    }

    // Create new concrete task
    const newTask = await this.taskService.createTask({ workspaceId, data });

    // Create/init new task assignments for each given assignee
    for (const assigneeId of data.assignees) {
      this.taskAssignmentService.createTaskAssignment({
        workspaceUserId: assigneeId,
        taskId: newTask.id,
      });
    }

    return;
  }
}
