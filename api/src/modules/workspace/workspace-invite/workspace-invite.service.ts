import { Injectable } from '@nestjs/common';
import { WorkspaceInviteRepository } from './persistence/workspace-invite.repository';

@Injectable()
export class WorkspaceInviteService {
  constructor(
    private readonly workspaceInviteRepository: WorkspaceInviteRepository,
  ) {}

  async createInviteLink(
    workspaceId: string,
    invitedByUserId: string | null,
  ): Promise<WorkspaceInviteEntity> {
    // Check if an active invite link already exists for this workspace
    const existingActiveInvite = await this.workspaceInviteRepository.findOne({
      where: { workspace: { id: workspaceId }, status: 'ACTIVE' },
    });

    if (existingActiveInvite) {
      return existingActiveInvite;
    }

    // If no active link exists, create a new one
    const workspace = await this.workspaceService.findById(workspaceId);
    if (!workspace) {
      throw new NotFoundException(`Workspace with ID ${workspaceId} not found`);
    }

    const newInvite = this.workspaceInviteRepository.create({
      workspace: { id: workspaceId },
      invitedBy: invitedByUserId ? { id: invitedByUserId } : null,
      id: uuidv4(), // Generate a unique invite token
      status: 'ACTIVE',
    });

    return this.workspaceInviteRepository.save(newInvite);
  }
}
