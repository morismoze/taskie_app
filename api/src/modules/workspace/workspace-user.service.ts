import { Injectable } from '@nestjs/common';
import { WorkspaceUserRolesDomain } from './domain/workspace-user-roles.domain';
import { WorkspaceRepository } from './persistence/workspace.repository';

@Injectable()
export class WorkspaceService {
  constructor(private readonly workspaceUserRepository: WorkspaceRepository) {}

  async getWorkspaceUserRoles(
    userId: string,
  ): Promise<WorkspaceUserRolesDomain> {
    const rolesInWorkspaces =
      await this.workspaceUserRepository.findWorkspaceUserRolesByUserId(userId);
    return rolesInWorkspaces.map((role) => ({
      workspaceId: role.workspaceId,
      role: role.role,
    }));
  }
}
