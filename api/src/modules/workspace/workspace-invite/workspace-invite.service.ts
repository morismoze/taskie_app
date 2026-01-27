import { HttpStatus, Injectable } from '@nestjs/common';
import { DateTime } from 'luxon';
import { WORKSPACE_INVITE_TOKEN_LENGTH } from 'src/common/helper/constants';
import { generateUniqueToken } from 'src/common/helper/util';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUser } from '../workspace-user-module/domain/workspace-user.domain';
import { WorkspaceUserService } from '../workspace-user-module/workspace-user.service';
import { WorkspaceInviteCore } from './domain/workspace-invite-core.domain';
import { WorkspaceInviteWithWorkspaceCoreAndCreatedByUserCoreAndUsedByWorkspaceUserCore } from './domain/workspace-invite-with-workspace-core-and-user-core.domain';
import { WorkspaceInviteWithWorkspaceWithCreatedByUser } from './domain/workspace-invite-with-workspace-with-created-by-user.domain';
import { WorkspaceInvite } from './domain/workspace-invite.domain';
import { WorkspaceInviteRepository } from './persistence/workspace-invite.repository';

@Injectable()
export class WorkspaceInviteService {
  constructor(
    private readonly workspaceInviteRepository: WorkspaceInviteRepository,
    private readonly workspaceUserService: WorkspaceUserService,
    private readonly unitOfWorkService: UnitOfWorkService,
  ) {}

  /**
   * Invite links will last up to 7 days and be one-time only
   */
  async createInviteToken({
    workspaceId,
    createdByWorkspaceUserId,
  }: {
    workspaceId: WorkspaceInvite['workspace']['id'];
    createdByWorkspaceUserId: WorkspaceUser['id'];
  }): Promise<WorkspaceInviteCore> {
    const token = generateUniqueToken(WORKSPACE_INVITE_TOKEN_LENGTH);
    const now = DateTime.now().toUTC();
    const expiresAt = now.plus({ days: 7 }).toISO();
    const newInvite = await this.workspaceInviteRepository.create({
      data: {
        token,
        workspaceId,
        createdById: createdByWorkspaceUserId,
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

  findByTokenWithWorkspace(
    token: WorkspaceInvite['token'],
  ): Promise<Nullable<WorkspaceInviteWithWorkspaceWithCreatedByUser>> {
    return this.workspaceInviteRepository.findByToken({
      token,
      relations: {
        workspace: {
          createdBy: true,
        },
      },
    });
  }

  findByTokenWithWorkspaceAndUser(
    token: WorkspaceInvite['token'],
  ): Promise<
    Nullable<WorkspaceInviteWithWorkspaceCoreAndCreatedByUserCoreAndUsedByWorkspaceUserCore>
  > {
    return this.workspaceInviteRepository.findByToken({
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
  }): Promise<WorkspaceInviteWithWorkspaceWithCreatedByUser> {
    const workspaceInvite = await this.findByTokenWithWorkspaceAndUser(token);

    // Check if the invite exists
    if (!workspaceInvite) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.NOT_FOUND_WORKSPACE_INVITE_TOKEN,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    // Check if user is already part of the workspace
    const existingWorkspaceUser =
      await this.workspaceUserService.findByUserIdAndWorkspaceId({
        userId: usedById,
        workspaceId: workspaceInvite.workspace.id,
      });

    if (existingWorkspaceUser !== null) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.WORKSPACE_INVITE_EXISTING_USER,
        },
        HttpStatus.BAD_REQUEST,
      );
    }

    // Check if that workspace invite was already used
    if (workspaceInvite.usedBy !== null) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.WORKSPACE_INVITE_ALREADY_USED,
        },
        HttpStatus.BAD_REQUEST,
      );
    }

    // Check if that workspace invite has expired
    const expiresAt = DateTime.fromJSDate(workspaceInvite.expiresAt).toISO()!;
    const now = DateTime.now().toUTC().toISO();

    if (expiresAt < now) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.WORKSPACE_INVITE_EXPIRED,
        },
        HttpStatus.BAD_REQUEST,
      );
    }

    // WorkspaceUserService is injected into this class only because of the
    // code below. There is no easy/not messy way to move this WorkspaceUserService
    // code to the WorkspaceService method, so we will leave it like this
    // for the sake of easier code understanding.
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
        });

        // Mark the invite as used
        const updatedInvite = await this.workspaceInviteRepository.markUsedBy({
          id: workspaceInvite.id,
          usedById: newWorkspaceUser.id,
          relations: {
            workspace: {
              createdBy: true,
            },
          },
        });

        if (!updatedInvite) {
          throw new ApiHttpException(
            {
              code: ApiErrorCode.INVALID_PAYLOAD,
            },
            HttpStatus.NOT_FOUND,
          );
        }

        return { updatedInvite };
      },
    );

    return updatedInvite;
  }
}
