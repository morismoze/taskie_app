import { Injectable } from '@nestjs/common';
import { User } from 'src/modules/user/domain/user.domain';
import { Workspace } from './domain/workspace.domain';
import { CreateVirtualWorkspaceUserRequest } from './dto/create-workspace-user.dto';

@Injectable()
export class WorkspaceService {
  constructor() {}

  async createVirtualUser(
    workspaceId: Workspace['id'],
    creatorId: User['id'],
    newVirtualUser: CreateVirtualWorkspaceUserRequest,
  ): Promise<void> {}
}
