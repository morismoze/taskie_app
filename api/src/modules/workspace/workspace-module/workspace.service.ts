import {
  ForbiddenException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { JwtPayload } from 'src/modules/auth/core/strategies/domain/jwt-payload.domain';
import { UserService } from 'src/modules/user/user.service';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from '../workspace-user-module/domain/workspace-user-status.enum';
import { WorkspaceUser } from '../workspace-user-module/domain/workspace-user.domain';
import { WorkspaceUserService } from '../workspace-user-module/workspace-user.service';
import { Workspace } from './domain/workspace.domain';
import { CreateVirtualWorkspaceUserRequest } from './dto/create-virtual-workspace-user-request.dto';
import { CreateVirtualWorkspaceUserResponse } from './dto/create-virtual-workspace-user-response.dto copy';
import { CreateWorkspaceRequest } from './dto/create-workspace-request.dto';
import { WorkspaceMembersResponse } from './dto/workspace-members-response.dto';
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
    data: CreateWorkspaceRequest,
  ): Promise<WorkspacesPreviewsResponse> {
    const ownerUser = await this.userService.findById(ownerId);

    if (!ownerUser) {
      // Corrupted access token
      throw new ForbiddenException();
    }

    // 1. create a new empty workspace
    const newWorkspace = await this.workspaceRepository.create({
      ownedBy: ownerUser,
      description: data.description,
      name: data.name,
      pictureUrl: null,
    });

    if (!newWorkspace) {
      throw new InternalServerErrorException();
    }

    // 2. create a new workspace user for the owner
    await this.workspaceUserService.create({
      workspaceId: newWorkspace.id,
      role: WorkspaceUserRole.MANAGER,
      userId: ownerUser.id,
      status: WorkspaceUserStatus.ACTIVE,
    });

    // 3. Refetch all owner user's workspaces
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
    creatorId: JwtPayload['userId'],
    payload: CreateVirtualWorkspaceUserRequest,
  ): Promise<CreateVirtualWorkspaceUserResponse> {
    const workspace = await this.workspaceRepository.findById(workspaceId);

    if (!workspace) {
      throw new NotFoundException();
    }

    // 1. Create core user
    const virtualUser = await this.userService.createVirtualUser(payload);

    // 2. Create a workspace user relation linking the user to the workspace
    await this.workspaceUserService.createVirtualUser(
      virtualUser.id,
      workspaceId,
    );

    const response: CreateVirtualWorkspaceUserResponse = workspace.members.map(
      (member) => ({
        id: member.id,
        workspaceRole: member.workspaceRole,
        user: {
          id: member.user.id,
          email: member.user.email,
          firstName: member.user.firstName,
          lastName: member.user.lastName,
          profileImageUrl: member.user.profileImageUrl,
          createdAt: member.user.createdAt,
        },
        isOwner: workspace.ownedBy.id === creatorId,
        status: member.status,
        createdAt: member.createdAt,
        deletedAt: member.deletedAt,
      }),
    );

    return response;
  }

  findById(id: Workspace['id']): Promise<Nullable<Workspace>> {
    return this.workspaceRepository.findById(id);
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

  async getWorkspaceMembers(
    workspaceId: string,
    requestUserId: string,
  ): Promise<WorkspaceMembersResponse> {
    const workspace = await this.findById(workspaceId);

    if (!workspace) {
      throw new NotFoundException();
    }

    return workspace.members.map((member) => ({
      id: member.id,
      workspaceRole: member.workspaceRole,
      user: {
        id: member.user.id,
        email: member.user.email,
        firstName: member.user.firstName,
        lastName: member.user.lastName,
        profileImageUrl: member.user.profileImageUrl,
        createdAt: member.user.createdAt,
      },
      isOwner: workspace.ownedBy.id === requestUserId,
      status: member.status,
      createdAt: member.createdAt,
      deletedAt: member.deletedAt,
    }));
  }
}
