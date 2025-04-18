import { Injectable } from '@nestjs/common';
import { WorkspaceUserRole } from './domain/workspace-user-role.enum';
import { WorkspaceUserDomain } from './domain/workspace-user.domain';
import { WorkspaceUserRepository } from './persistence/workspace-user.repository';

@Injectable()
export class WorkspaceUserService {
  constructor(
    private readonly workspaceUserRepository: WorkspaceUserRepository,
  ) {}

  async getWorkspaceUserMemberships(
    userId: string,
  ): Promise<WorkspaceUserDomain[]> {
    const workspaceUsers =
      await this.workspaceUserRepository.findByUserId(userId);

    return workspaceUsers.map((workspaceUser) => {
      const isOwner = workspaceUser.workspace.owner.id === userId;

      return {
        id: workspaceUser.id,
        createdAt: workspaceUser.createdAt,
        userId: workspaceUser.user.id,
        workspaceId: workspaceUser.workspace.id,
        role: workspaceUser.workspaceRole as WorkspaceUserRole,
        isOwner,
      };
    });
  }
}
