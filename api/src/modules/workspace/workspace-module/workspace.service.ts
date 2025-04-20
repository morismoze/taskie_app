import { Injectable, NotFoundException } from '@nestjs/common';
import { UserService } from 'src/modules/user/user.service';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUser } from '../workspace-user-module/domain/workspace-user.domain';
import { WorkspaceUserService } from '../workspace-user-module/workspace-user.service';
import { Workspace } from './domain/workspace.domain';
import { CreateVirtualWorkspaceUserRequest } from './dto/create-virtual-workspace-user-request.dto';
import { CreateVirtualWorkspaceUserResponse } from './dto/create-virtual-workspace-user-response.dto copy';
import { CreateWorkspaceRequest } from './dto/create-workspace-request.dto';
import { WorkspacesPreviewsResponse } from './dto/workspaces-preview-response.dto';
import { WorkspaceRepository } from './persistence/workspace.repository';

@Injectable()
export class WorkspaceService {
  constructor(
    private readonly workspaceRepository: WorkspaceRepository,
    private readonly workspaceUserService: WorkspaceUserService,
    private readonly userService: UserService,
  ) {}

  async create(
    ownerId: Workspace['ownedBy']['id'],
    payload: CreateWorkspaceRequest,
  ): Promise<WorkspacesPreviewsResponse> {
    const newWorkspace = await this.workspaceRepository.create(
      payload,
      ownerId,
    );

    // Add owner as the first workspace user of that newly created workspace
    await this.workspaceUserService.create({
      workspaceId: newWorkspace.id,
      userId: ownerId,
      role: WorkspaceUserRole.MANAGER,
    });

    const userWorkspaces =
      await this.workspaceRepository.findAllByUserId(ownerId);

    const response: WorkspacesPreviewsResponse = userWorkspaces.map(
      (workspace) => ({
        id: workspace.id,
        name: workspace.name,
        description: workspace.description,
        pictureUrl: workspace.pictureUrl,
      }),
    );

    return response;
  }

  async createVirtualUser(
    workspaceId: Workspace['id'],
    creatorId: Workspace['ownedBy']['id'],
    payload: CreateVirtualWorkspaceUserRequest,
  ): Promise<CreateVirtualWorkspaceUserResponse> {
    const workspace = await this.workspaceRepository.findById(workspaceId);

    if (!workspace) {
      throw new NotFoundException();
    }

    const virtualUser =
      await this.userService.createVirtualUser(newVirtualUser);
    const workspaceUser = await this.workspaceUserService.createVirtual(
      virtualUser.id,
      workspaceId,
    );

    return {
      ...workspaceUser,
    };
  }

  async getUserWorkspaces(
    userId: WorkspaceUser['user']['id'],
  ): Promise<WorkspacesPreviewsResponse> {
    const workspaceUserMemberships =
      await this.workspaceUserService.getWorkspaceUserMemberships(userId);
    const response: WorkspacesPreviewsResponse = workspaceUserMemberships.map(
      (workspaceUser) => ({
        id: workspaceUser.workspace.id,
        name: workspaceUser.workspace.name,
        description: workspaceUser.workspace.description,
        pictureUrl: workspaceUser.workspace.pictureUrl,
      }),
    );

    return response;
  }
}
