import { HttpStatus, Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { WorkspaceLeaderboardResponse } from '../workspace-module/dto/response/workspace-leaderboard-response.dto';
import { WorkspaceUserCore } from './domain/workspace-user-core.domain';
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
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    createdById: WorkspaceUser['id'] | null;
    userId: WorkspaceUser['user']['id'];
    workspaceRole: WorkspaceUser['workspaceRole'];
  }): Promise<WorkspaceUserWithCreatedByUser> {
    const workspaceUser = await this.workspaceUserRepository.create({
      data: {
        workspaceId,
        createdById,
        userId,
        workspaceRole,
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

  findByIdAndWorkspaceId({
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
  findByUserIdAndWorkspaceId({
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
  findAllByUserIdWithWorkspace(
    userId: WorkspaceUser['user']['id'],
  ): Promise<WorkspaceUserWithWorkspaceCore[]> {
    return this.workspaceUserRepository.findAllByUserId({
      userId,
      relations: { workspace: true },
    });
  }

  findAllByUserId(
    userId: WorkspaceUser['user']['id'],
  ): Promise<WorkspaceUserWithWorkspaceCore[]> {
    return this.workspaceUserRepository.findAllByUserId({
      userId,
    });
  }

  findAllByIds({
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

  findAllByWorkspaceId(
    workspaceId: WorkspaceUser['workspace']['id'],
  ): Promise<WorkspaceUserCore[]> {
    return this.workspaceUserRepository.findAllByWorkspaceId({
      workspaceId,
    });
  }

  async countByWorkspace(
    workspaceId: string,
    options: {
      role?: WorkspaceUser['workspaceRole'];
      excludeUserId?: string;
      onlyRealUsers?: boolean;
    } = {},
  ): Promise<number> {
    return this.workspaceUserRepository.countByWorkspace(workspaceId, options);
  }

  async update({
    id,
    data,
  }: {
    id: WorkspaceUser['id'];
    data: Partial<Pick<WorkspaceUser, 'workspaceRole'>>;
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
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    return updatedWorkspaceUser;
  }

  async delete(id: WorkspaceUser['user']['id']): Promise<void> {
    const result = await this.workspaceUserRepository.delete(id);

    if (!result) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }
  }

  getLeaderboardData(
    workspaceId: WorkspaceUser['workspace']['id'],
  ): Promise<WorkspaceLeaderboardResponse[]> {
    return this.workspaceUserRepository.getWorkspaceLeaderboard(workspaceId);
  }
}
