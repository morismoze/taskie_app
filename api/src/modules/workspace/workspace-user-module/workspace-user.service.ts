import { Injectable } from '@nestjs/common';
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
    userId,
    role,
    status,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    userId: WorkspaceUser['user']['id'];
    role: WorkspaceUserRole;
    status: WorkspaceUserStatus;
  }): Promise<WorkspaceUser> {
    return this.workspaceUserRepository.create(
      userId,
      workspaceId,
      role,
      status,
    );
  }

  async createVirtual(
    userId: WorkspaceUser['user']['id'],
    workspaceId: WorkspaceUser['workspace']['id'],
  ): Promise<WorkspaceUser> {
    return this.workspaceUserRepository.create(
      userId,
      workspaceId,
      WorkspaceUserRole.MEMBER,
      WorkspaceUserStatus.ACTIVE,
    );
  }

  async getWorkspaceUserMemberships(userId: string): Promise<WorkspaceUser[]> {
    return this.workspaceUserRepository.findAllByUserId(userId);
  }
}
