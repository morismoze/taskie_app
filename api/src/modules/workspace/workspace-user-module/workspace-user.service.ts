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
    workspaceId,
    userId,
    workspaceRole,
    status,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    userId: WorkspaceUser['user']['id'];
    workspaceRole: WorkspaceUser['workspaceRole'];
    status: WorkspaceUser['status'];
  }): Promise<WorkspaceUser> {
    const workspaceUser = await this.workspaceUserRepository.create({
      workspaceId,
      userId,
      workspaceRole,
      status,
      createdById: null,
    });

    if (!workspaceUser) {
      throw new InternalServerErrorException();
    }

    return workspaceUser;
  }

  async createVirtualUser({
    workspaceId,
    userId,
    createdById,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    userId: WorkspaceUser['user']['id'];
    createdById: WorkspaceUser['id'];
  }): Promise<WorkspaceUser> {
    const workspaceUser = await this.workspaceUserRepository.create({
      workspaceId,
      userId,
      workspaceRole: WorkspaceUserRole.MEMBER,
      status: WorkspaceUserStatus.ACTIVE,
      createdById,
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
