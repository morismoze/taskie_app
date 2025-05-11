import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { WORKSPACE_INVITE_LINK_LENGTH } from 'src/common/helper/constants';
import { generateUniqueToken } from 'src/common/helper/util';
import { Nullable } from 'src/common/types/nullable.type';
import { WorkspaceInviteCore } from './domain/workspace-invite-core.domain';
import { WorkspaceInviteStatus } from './domain/workspace-invite-status.enum';
import { WorkspaceInviteWithWorkspaceCore } from './domain/workspace-invite-with-workspace-core.domain';
import { WorkspaceInvite } from './domain/workspace-invite.domain';
import { WorkspaceInviteRepository } from './persistence/workspace-invite.repository';

@Injectable()
export class WorkspaceInviteService {
  constructor(
    private readonly workspaceInviteRepository: WorkspaceInviteRepository,
  ) {}

  /**
   * Invite links will last up to 1 day and be one-time only
   */

  async createInviteLink({
    workspaceId,
    createdById,
  }: {
    workspaceId: WorkspaceInvite['workspace']['id'];
    createdById: WorkspaceInvite['createdBy']['id'];
  }): Promise<WorkspaceInviteCore> {
    const token = generateUniqueToken(WORKSPACE_INVITE_LINK_LENGTH);
    const now = new Date();
    const twentyFourHoursInMillis = 24 * 60 * 60 * 1000;
    const expiresAt = new Date(now.getTime() + twentyFourHoursInMillis);

    const newInvite = await this.workspaceInviteRepository.create({
      data: {
        token,
        workspaceId,
        createdById,
        expiresAt,
        status: WorkspaceInviteStatus.ACTIVE,
      },
    });

    if (!newInvite) {
      throw new InternalServerErrorException();
    }

    return newInvite;
  }

  async findByToken(
    token: WorkspaceInvite['token'],
  ): Promise<Nullable<WorkspaceInviteCore>> {
    return await this.workspaceInviteRepository.findByToken({
      token,
    });
  }

  async findByTokenWithWorkspace(
    token: WorkspaceInvite['token'],
  ): Promise<Nullable<WorkspaceInviteWithWorkspaceCore>> {
    return await this.workspaceInviteRepository.findByToken({
      token,
      relations: {
        workspace: true,
      },
    });
  }

  async claimInvite({
    token,
    usedBy,
  }: {
    token: WorkspaceInvite['token'];
    usedBy: WorkspaceInvite['usedBy'];
  }): Promise<Nullable<WorkspaceInviteCore>> {
    const workspaceInvite = await this.workspaceInviteRepository.findByToken({
      token,
    });

    // Check if workspace invite with that token exists
    if (!workspaceInvite) {
      throw new NotFoundException();
    }

    // Check if that woekspace invite was already used or expired
    if (
      workspaceInvite.status === WorkspaceInviteStatus.USED ||
      workspaceInvite.expiresAt < new Date()
    ) {
      throw new BadRequestException();
    }

    return await this.workspaceInviteRepository.update({
      id: workspaceInvite.id,
      data: {
        usedBy,
        status: WorkspaceInviteStatus.USED,
      },
    });
  }
}
