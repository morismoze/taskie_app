import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
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
    workspace,
    user,
    workspaceRole,
    status,
  }: {
    workspace: WorkspaceUser['workspace'];
    user: WorkspaceUser['user'];
    workspaceRole: WorkspaceUserRole;
    status: WorkspaceUserStatus;
  }): Promise<WorkspaceUser> {
    const workspaceUser = await this.workspaceUserRepository.create({
      workspace,
      user,
      workspaceRole,
      status,
      createdBy: null,
    });

    if (!workspaceUser) {
      throw new InternalServerErrorException();
    }

    return workspaceUser;
  }

  async createVirtualUser(
    workspace: WorkspaceUser['workspace'],
    user: WorkspaceUser['user'],
    createdBy: WorkspaceUser['createdBy'],
  ): Promise<WorkspaceUser> {
    const workspaceUser = await this.workspaceUserRepository.create({
      workspace,
      user,
      workspaceRole: WorkspaceUserRole.MEMBER,
      status: WorkspaceUserStatus.ACTIVE,
      createdBy,
    });

    if (!workspaceUser) {
      throw new InternalServerErrorException();
    }

    return workspaceUser;
  }

  async findByUserId(
    userId: WorkspaceUser['user']['id'],
  ): Promise<Nullable<WorkspaceUser>> {
    return this.workspaceUserRepository.findByUserId(userId);
  }

  async getWorkspaceUserMemberships(userId: string): Promise<WorkspaceUser[]> {
    return this.workspaceUserRepository.findAllByUserId(userId);
  }
}
