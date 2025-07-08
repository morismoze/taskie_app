import { HttpStatus, Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/ApiHttpException.type';
import { WorkspaceLeaderboardResponse } from '../workspace-module/dto/response/workspace-leaderboard-response.dto';
import { WorkspaceUserCore } from './domain/workspace-user-core.domain';
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
  }): Promise<WorkspaceUserCore> {
    const workspaceUser = await this.workspaceUserRepository.create({
      data: {
        workspaceId,
        createdById,
        userId,
        workspaceRole,
        status,
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

    return workspaceUser;
  }

  async findById(
    workspaceUserId: WorkspaceUser['id'],
  ): Promise<Nullable<WorkspaceUserCore>> {
    return this.workspaceUserRepository.findById({ id: workspaceUserId });
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

  async update({
    id,
    data,
  }: {
    id: WorkspaceUser['id'];
    data: Partial<WorkspaceUserCore>;
  }): Promise<WorkspaceUserWithUser> {
    const workspaceUser = await this.findById(id);

    if (!workspaceUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const updatedWorkspaceUserUser = await this.workspaceUserRepository.update({
      id,
      data,
      relations: {
        user: true,
      },
    });

    if (!updatedWorkspaceUserUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return updatedWorkspaceUserUser;
  }

  async delete({
    workspaceId,
    workspaceUserId,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    workspaceUserId: WorkspaceUser['user']['id'];
  }): Promise<void> {
    const workspaceUser = await this.findById(workspaceUserId);

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

  async getLeaderboardData(
    workspaceId: WorkspaceUser['workspace']['id'],
  ): Promise<WorkspaceLeaderboardResponse> {
    const leaderboard =
      this.workspaceUserRepository.getWorkspaceLeaderboard(workspaceId);
    return leaderboard;
  }
}
