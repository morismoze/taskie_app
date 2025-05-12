import { HttpStatus, Injectable } from '@nestjs/common';
import { WORKSPACE_INVITE_LINK_LENGTH } from 'src/common/helper/constants';
import { generateUniqueToken } from 'src/common/helper/util';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/ApiHttpException.type';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from '../workspace-user-module/domain/workspace-user-status.enum';
import { WorkspaceUserService } from '../workspace-user-module/workspace-user.service';
import { WorkspaceInviteCore } from './domain/workspace-invite-core.domain';
import { WorkspaceInviteStatus } from './domain/workspace-invite-status.enum';
import { WorkspaceInviteWithWorkspaceCoreAndCreatedByUserCore } from './domain/workspace-invite-with-workspace-core-and-user-core.domain';
import { WorkspaceInviteWithWorkspaceCore } from './domain/workspace-invite-with-workspace-core.domain';
import { WorkspaceInvite } from './domain/workspace-invite.domain';
import { WorkspaceInviteRepository } from './persistence/workspace-invite.repository';

@Injectable()
export class WorkspaceInviteService {
  constructor(
    private readonly workspaceInviteRepository: WorkspaceInviteRepository,
    private readonly workspaceUserService: WorkspaceUserService,
  ) {}

  /**
   * Invite links will last up to 1 day and be one-time only
   */

  async createInviteLink({
    workspaceId,
    createdById,
  }: {
    workspaceId: WorkspaceInvite['workspace']['id'];
    createdById: WorkspaceInvite['createdBy']['id'];
  }): Promise<WorkspaceInviteCore> {
    // Check if workspace user by user ID exists
    const createdByWorkspaceUser =
      await this.workspaceUserService.findByUserId(createdById);

    if (!createdByWorkspaceUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const token = generateUniqueToken(WORKSPACE_INVITE_LINK_LENGTH);
    const now = new Date();
    const twentyFourHoursInMillis = 24 * 60 * 60 * 1000;
    const expiresAt = new Date(now.getTime() + twentyFourHoursInMillis);

    const newInvite = await this.workspaceInviteRepository.create({
      data: {
        token,
        workspaceId,
        createdById,
        expiresAt,
        status: WorkspaceInviteStatus.ACTIVE,
      },
    });

    if (!newInvite) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return newInvite;
  }

  async findByTokenWith(
    token: WorkspaceInvite['token'],
  ): Promise<Nullable<WorkspaceInviteCore>> {
    return await this.workspaceInviteRepository.findByToken({
      token,
    });
  }

  async findByTokenWithWorkspace(
    token: WorkspaceInvite['token'],
  ): Promise<Nullable<WorkspaceInviteWithWorkspaceCore>> {
    return await this.workspaceInviteRepository.findByToken({
      token,
      relations: {
        workspace: true,
      },
    });
  }

  async findByTokenWithWorkspaceAndUser(
    token: WorkspaceInvite['token'],
  ): Promise<Nullable<WorkspaceInviteWithWorkspaceCoreAndCreatedByUserCore>> {
    return await this.workspaceInviteRepository.findByToken({
      token,
      relations: {
        workspace: true,
        createdBy: true,
      },
    });
  }

  async claimInvite({
    token,
    usedById,
  }: {
    token: WorkspaceInvite['token'];
    usedById: WorkspaceInvite['usedBy']['user']['id'];
  }): Promise<Nullable<WorkspaceInviteCore>> {
    const workspaceInvite = await this.findByTokenWithWorkspaceAndUser(token);

    // Check if the invite exists
    if (!workspaceInvite) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    // Check if that workspace invite was already used or expired
    if (
      workspaceInvite.status === WorkspaceInviteStatus.USED ||
      workspaceInvite.expiresAt < new Date()
    ) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.WORKSPACE_INVITE_ALREADY_USED,
        },
        HttpStatus.BAD_REQUEST,
      );
    }

    // Create a new workspace user
    const newWorkspaceUser = await this.workspaceUserService.create({
      workspaceId: workspaceInvite.workspace.id,
      userId: usedById,
      createdById: workspaceInvite.createdBy.id,
      workspaceRole: WorkspaceUserRole.MEMBER,
      status: WorkspaceUserStatus.ACTIVE,
    });

    return await this.workspaceInviteRepository.markUsedBy({
      id: workspaceInvite.id,
      usedById: newWorkspaceUser.id,
    });
  }
}
