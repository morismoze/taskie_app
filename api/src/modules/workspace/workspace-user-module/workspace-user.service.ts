import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { WorkspaceUserCore } from './domain/workspace-user-core.domain';
import { WorkspaceUserRole } from './domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from './domain/workspace-user-status.enum';
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
      throw new InternalServerErrorException();
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
  async findByUserId(
    userId: WorkspaceUser['user']['id'],
  ): Promise<Nullable<WorkspaceUserCore>> {
    return this.workspaceUserRepository.findByUserId({ userId });
  }

  /**
   * This function returns workspace user memberships a user has in different workspaces
   */
  async findAllByUserIdWithWorkspace(
    userId: WorkspaceUser['user']['id'],
  ): Promise<WorkspaceUser[]> {
    return this.workspaceUserRepository.findAllByUserId({
      userId,
      relations: { workspace: true },
    });
  }
}
