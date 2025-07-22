import { HttpStatus, Injectable } from '@nestjs/common';
import { WORKSPACE_INVITE_TOKEN_LENGTH } from 'src/common/helper/constants';
import { generateUniqueToken } from 'src/common/helper/util';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/ApiHttpException.type';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from '../workspace-user-module/domain/workspace-user-status.enum';
import { WorkspaceUser } from '../workspace-user-module/domain/workspace-user.domain';
import { WorkspaceUserService } from '../workspace-user-module/workspace-user.service';
import { WorkspaceInviteCore } from './domain/workspace-invite-core.domain';
import { WorkspaceInviteWithWorkspaceCoreAndCreatedByUserCoreAndUsedByWorkspaceUserCore } from './domain/workspace-invite-with-workspace-core-and-user-core.domain';
import { WorkspaceInviteWithWorkspaceCore } from './domain/workspace-invite-with-workspace-core.domain';
import { WorkspaceInvite } from './domain/workspace-invite.domain';
import { TransactionalWorkspaceInviteRepository } from './persistence/transactional/transactional-workspace-invite.repository';
import { WorkspaceInviteRepository } from './persistence/workspace-invite.repository';

@Injectable()
export class WorkspaceInviteService {
  constructor(
    private readonly workspaceInviteRepository: WorkspaceInviteRepository,
    private readonly transactionalWorkspaceInviteRepository: TransactionalWorkspaceInviteRepository,
    private readonly workspaceUserService: WorkspaceUserService,
    private readonly unitOfWorkService: UnitOfWorkService,
  ) {}

  /**
   * Invite links will last up to 1 day and be one-time only
   */

  async createInviteToken({
    workspaceId,
    createdById,
  }: {
    workspaceId: WorkspaceInvite['workspace']['id'];
    createdById: WorkspaceUser['id'];
  }): Promise<WorkspaceInviteCore> {
    // Check if workspace user by user ID exists
    const createdByWorkspaceUser =
      await this.workspaceUserService.findByUserIdAndWorkspaceId({
        userId: createdById,
        workspaceId,
      });

    if (!createdByWorkspaceUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const token = generateUniqueToken(WORKSPACE_INVITE_TOKEN_LENGTH);
    const now = new Date();
    const twentyFourHoursInMillis = 24 * 60 * 60 * 1000;
    const expiresAt = new Date(
      now.getTime() + twentyFourHoursInMillis,
    ).toISOString();

    const newInvite = await this.workspaceInviteRepository.create({
      data: {
        token,
        workspaceId,
        createdById: createdByWorkspaceUser.id,
        expiresAt,
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
  ): Promise<
    Nullable<WorkspaceInviteWithWorkspaceCoreAndCreatedByUserCoreAndUsedByWorkspaceUserCore>
  > {
    return await this.workspaceInviteRepository.findByToken({
      token,
      relations: {
        workspace: true,
        createdBy: true,
        usedBy: true,
      },
    });
  }

  async claimInvite({
    token,
    usedById,
  }: {
    token: WorkspaceInvite['token'];
    usedById: User['id'];
  }): Promise<WorkspaceInviteWithWorkspaceCore> {
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
      workspaceInvite.usedBy !== null ||
      workspaceInvite.expiresAt < new Date().toISOString()
    ) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.WORKSPACE_INVITE_ALREADY_USED,
        },
        HttpStatus.BAD_REQUEST,
      );
    }

    const { updatedInvite } = await this.unitOfWorkService.withTransaction(
      async () => {
        // Create a new workspace user
        const newWorkspaceUser = await this.workspaceUserService.create({
          workspaceId: workspaceInvite.workspace.id,
          userId: usedById,
          createdById: workspaceInvite.createdBy
            ? workspaceInvite.createdBy.id
            : null,
          workspaceRole: WorkspaceUserRole.MEMBER,
          status: WorkspaceUserStatus.ACTIVE,
        });

        // Mark the invite as used
        const updatedInvite =
          await this.transactionalWorkspaceInviteRepository.markUsedBy({
            id: workspaceInvite.id,
            usedById: newWorkspaceUser.id,
            relations: {
              workspace: true,
            },
          });

        if (!updatedInvite) {
          throw new ApiHttpException(
            {
              code: ApiErrorCode.SERVER_ERROR,
            },
            HttpStatus.INTERNAL_SERVER_ERROR,
          );
        }

        return { updatedInvite };
      },
    );

    return updatedInvite;
  }
}
