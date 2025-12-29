import { HttpStatus, Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { WorkspaceLeaderboardResponse } from '../workspace-module/dto/response/workspace-leaderboard-response.dto';
import { WorkspaceUserCore } from './domain/workspace-user-core.domain';
import { WorkspaceUserRole } from './domain/workspace-user-role.enum';
import { WorkspaceUserWithCreatedByUser } from './domain/workspace-user-with-created-by.domain';
import { WorkspaceUserWithUser } from './domain/workspace-user-with-user.domain';
import { WorkspaceUserWithWorkspaceCore } from './domain/workspace-user-with-workspace.domain';
import { WorkspaceUser } from './domain/workspace-user.domain';
import { WorkspaceUserRepository } from './persistence/workspace-user.repository';

@Injectable()
export class WorkspaceUserService {
  constructor(
    private readonly workspaceUserRepository: WorkspaceUserRepository,
  ) {}

  async create({
    workspaceId,
    createdById,
    userId,
    workspaceRole,
    status,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    createdById: WorkspaceUser['id'] | null;
    userId: WorkspaceUser['user']['id'];
    workspaceRole: WorkspaceUser['workspaceRole'];
    status: WorkspaceUser['status'];
  }): Promise<WorkspaceUserWithCreatedByUser> {
    const workspaceUser = await this.workspaceUserRepository.create({
      data: {
        workspaceId,
        createdById,
        userId,
        workspaceRole,
        status,
      },
      relations: {
        createdBy: {
          user: true,
        },
      },
    });

    if (!workspaceUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    const createdBy =
      workspaceUser.createdBy === null
        ? null
        : {
            id: workspaceUser.createdBy.id,
            firstName: workspaceUser.createdBy.user.firstName,
            lastName: workspaceUser.createdBy.user.lastName,
            profileImageUrl: workspaceUser.createdBy.user.profileImageUrl,
          };

    return {
      ...workspaceUser,
      createdBy,
    };
  }

  async findByIdAndWorkspaceId({
    workspaceId,
    id,
  }: {
    id: WorkspaceUser['id'];
    workspaceId: WorkspaceUser['workspace']['id'];
  }): Promise<Nullable<WorkspaceUserCore>> {
    return this.workspaceUserRepository.findByIdAndWorkspaceId({
      id,
      workspaceId,
    });
  }

  /**
   * This function returns workspace user membership a user has in a specific workspace
   */
  async findByUserIdAndWorkspaceId({
    userId,
    workspaceId,
  }: {
    userId: WorkspaceUser['user']['id'];
    workspaceId: WorkspaceUser['workspace']['id'];
  }): Promise<Nullable<WorkspaceUserCore>> {
    return this.workspaceUserRepository.findByUserIdAndWorkspaceId({
      userId,
      workspaceId,
    });
  }

  async findByIdAndWorkspaceIdWithUser({
    id,
    workspaceId,
  }: {
    id: WorkspaceUser['user']['id'];
    workspaceId: WorkspaceUser['workspace']['id'];
  }): Promise<Nullable<WorkspaceUserWithUser>> {
    const workspaceUser =
      await this.workspaceUserRepository.findByIdAndWorkspaceId({
        id: id,
        workspaceId,
        relations: {
          user: true,
        },
      });

    return workspaceUser;
  }

  async findByIdAndWorkspaceIdWithUserAndCreatedByUser({
    id,
    workspaceId,
  }: {
    id: WorkspaceUser['user']['id'];
    workspaceId: WorkspaceUser['workspace']['id'];
  }): Promise<
    Nullable<WorkspaceUserWithUser & WorkspaceUserWithCreatedByUser>
  > {
    const workspaceUser =
      await this.workspaceUserRepository.findByIdAndWorkspaceId({
        id: id,
        workspaceId,
        relations: {
          user: true,
          createdBy: {
            user: true,
          },
        },
      });

    if (workspaceUser == null) {
      return null;
    }

    const createdBy =
      workspaceUser.createdBy === null
        ? null
        : {
            id: workspaceUser.createdBy.id,
            firstName: workspaceUser.createdBy.user.firstName,
            lastName: workspaceUser.createdBy.user.lastName,
            profileImageUrl: workspaceUser.createdBy.user.profileImageUrl,
          };

    return {
      ...workspaceUser,
      createdBy,
    };
  }

  async findByIdsAndWorkspaceIdWithUserAndCreatedByUser({
    ids,
    workspaceId,
  }: {
    ids: Array<WorkspaceUser['user']['id']>;
    workspaceId: WorkspaceUser['workspace']['id'];
  }): Promise<
    Nullable<Array<WorkspaceUserWithUser & WorkspaceUserWithCreatedByUser>>
  > {
    const workspaceUsers =
      await this.workspaceUserRepository.findByIdsAndWorkspaceId({
        ids: ids,
        workspaceId,
        relations: {
          user: true,
          createdBy: {
            user: true,
          },
        },
      });

    // We want to return null in case only some users were find by the provided
    // IDs. We are going by the logic "all or nothing".
    if (workspaceUsers.length !== ids.length) {
      return null;
    }

    const mappedUsers = workspaceUsers.map((workspaceUser) => {
      const createdBy =
        workspaceUser.createdBy === null
          ? null
          : {
              id: workspaceUser.createdBy.id,
              firstName: workspaceUser.createdBy.user.firstName,
              lastName: workspaceUser.createdBy.user.lastName,
              profileImageUrl: workspaceUser.createdBy.user.profileImageUrl,
            };

      return {
        ...workspaceUser,
        createdBy,
      };
    });

    return mappedUsers;
  }

  /**
   * This function returns workspace user memberships a user has in
   * different workspaces with workspace relation loaded.
   */
  async findAllByUserIdWithWorkspace(
    userId: WorkspaceUser['user']['id'],
  ): Promise<WorkspaceUserWithWorkspaceCore[]> {
    return this.workspaceUserRepository.findAllByUserId({
      userId,
      relations: { workspace: true },
    });
  }

  async findAllByIds({
    workspaceId,
    ids,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    ids: WorkspaceUser['id'][];
  }): Promise<WorkspaceUserCore[]> {
    return this.workspaceUserRepository.findAllByIds({
      workspaceId,
      ids,
    });
  }

  async findAllByWorkspaceId(
    workspaceId: WorkspaceUser['workspace']['id'],
  ): Promise<WorkspaceUserCore[]> {
    return this.workspaceUserRepository.findAllByWorkspaceId({
      workspaceId,
    });
  }

  async update({
    id,
    data,
  }: {
    id: WorkspaceUser['id'];
    data: Partial<{
      workspaceRole: WorkspaceUserRole;
      firstName: string;
      lastName: string;
    }>;
  }): Promise<WorkspaceUserWithUser> {
    const updatedWorkspaceUser = await this.workspaceUserRepository.update({
      id,
      data,
      relations: {
        user: true,
      },
    });

    if (!updatedWorkspaceUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return updatedWorkspaceUser;
  }

  async delete({
    workspaceId,
    workspaceUserId,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    workspaceUserId: WorkspaceUser['user']['id'];
  }): Promise<void> {
    const workspaceUser = await this.findByIdAndWorkspaceId({
      workspaceId,
      id: workspaceUserId,
    });

    if (!workspaceUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    await this.workspaceUserRepository.delete({
      workspaceId,
      workspaceUserId: workspaceUser.id,
    });
  }

  async getWorkspaceUserAccumulatedPoints({
    workspaceId,
    workspaceUserId,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    workspaceUserId: WorkspaceUser['id'];
  }): Promise<Nullable<number>> {
    return this.workspaceUserRepository.getWorkspaceUserAccumulatedPoints({
      workspaceId,
      workspaceUserId,
    });
  }

  async getLeaderboardData(
    workspaceId: WorkspaceUser['workspace']['id'],
  ): Promise<WorkspaceLeaderboardResponse> {
    const leaderboardData =
      await this.workspaceUserRepository.getWorkspaceLeaderboard(workspaceId);

    return leaderboardData.map((row) => ({
      ...row,
      accumulatedPoints: Number(row.accumulatedPoints),
      completedTasks: Number(row.completedTasks),
    }));
  }
}
