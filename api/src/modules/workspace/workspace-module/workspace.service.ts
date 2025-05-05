import {
  ForbiddenException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { JwtPayload } from 'src/modules/auth/core/strategies/domain/jwt-payload.domain';
import { TaskService } from 'src/modules/task/task-module/task.service';
import { UserService } from 'src/modules/user/user.service';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from '../workspace-user-module/domain/workspace-user-status.enum';
import { WorkspaceUser } from '../workspace-user-module/domain/workspace-user.domain';
import { WorkspaceUserService } from '../workspace-user-module/workspace-user.service';
import { Workspace } from './domain/workspace.domain';
import { CreateVirtualWorkspaceUserRequest } from './dto/create-virtual-workspace-user-request.dto';
import { CreateWorkspaceRequest } from './dto/create-workspace-request.dto';
import { WorkspaceMembersResponse } from './dto/workspace-members-response.dto';
import { WorkspaceTasksRequestQuery } from './dto/workspace-tasks-request.dto';
import { WorkspaceTasksResponse } from './dto/workspace-tasks-response.dto';
import { WorkspacesResponse } from './dto/workspaces-response.dto';
import { WorkspaceRepository } from './persistence/workspace.repository';

@Injectable()
export class WorkspaceService {
  constructor(
    private readonly workspaceRepository: WorkspaceRepository,
    private readonly workspaceUserService: WorkspaceUserService,
    private readonly userService: UserService,
    private readonly taskService: TaskService,
  ) {}

  async create({
    data,
    createdById,
  }: {
    createdById: Workspace['createdBy']['id'];
    data: CreateWorkspaceRequest;
  }): Promise<WorkspacesResponse> {
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

    // 3. Refetch all owner user's workspaces
    const userWorkspaces = await this.workspaceRepository.findAllByUserId({
      userId: createdById,
    });

    const response: WorkspacesResponse = userWorkspaces.map((workspace) => ({
      id: workspace.id,
      name: workspace.name,
      description: workspace.description,
      pictureUrl: workspace.pictureUrl,
    }));

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
  }): Promise<WorkspaceMembersResponse> {
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
    const virtualUser = await this.userService.createVirtualUser(data);

    // 2. Create a workspace user relation linking the user to the workspace
    await this.workspaceUserService.createVirtualUser({
      workspaceId: workspace.id,
      userId: virtualUser.id,
      createdById: creatorWorkspaceUser.id,
    });

    const response: WorkspaceMembersResponse = workspace.members.map(
      (member) => ({
        id: member.id,
        firstName: member.user.firstName,
        lastName: member.user.lastName,
        profileImageUrl: member.user.profileImageUrl,
      }),
    );

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
    workspaceId: string,
  ): Promise<WorkspaceMembersResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
      relations: {
        members: { user: true },
      },
    });

    if (!workspace) {
      throw new NotFoundException();
    }

    const response: WorkspaceMembersResponse = workspace.members.map(
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
    workspaceId: string;
    query: WorkspaceTasksRequestQuery;
  }): Promise<WorkspaceTasksResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
    });

    if (!workspace) {
      throw new NotFoundException();
    }

    const { data: taskAssignments, total } =
      await this.taskService.getTasksByWorkspaceWithAssignees({
        workspaceId,
        query,
      });

    const response: WorkspaceTasksResponse = {
      data: taskAssignments,
      total,
    };

    return response;
  }
}
