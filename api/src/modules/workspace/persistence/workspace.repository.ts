import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { WorkspaceUser } from './workspace-user.entity';
import { Workspace } from './workspace.entity';

@Injectable()
export class WorkspaceRepository {
  constructor(
    @InjectRepository(Workspace)
    private readonly workspaceRepo: Repository<Workspace>,
    @InjectRepository(WorkspaceUser)
    private readonly workspaceUserRepo: Repository<WorkspaceUser>,
  ) {}

  async findWorkspaceUserRolesByUserId(
    userId: string,
  ): Promise<
    { workspaceId: Workspace['id']; role: WorkspaceUser['workspaceRole'] }[]
  > {
    const workspaceUserRoles = await this.workspaceUserRepo
      .createQueryBuilder('workspaceUser')
      .leftJoin('workspaceUser.workspace', 'workspace')
      .leftJoin('workspaceUser.user', 'user')
      .select(['workspace.id', 'workspaceUser.workspaceRole'])
      .where('user.id = :userId', { userId })
      .getRawMany();

    return workspaceUserRoles.map((role) => ({
      workspaceId: role.workspace.id,
      role: role.workspaceRole,
    }));
  }
}
