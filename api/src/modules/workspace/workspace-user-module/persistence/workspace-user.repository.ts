import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { WorkspaceUser } from './workspace-user.entity';

@Injectable()
export class WorkspaceUserRepository {
  constructor(
    @InjectRepository(WorkspaceUser)
    private readonly workspaceUserRepo: Repository<WorkspaceUser>,
  ) {}

  async findByUserId(userId: string): Promise<WorkspaceUser[]> {
    return await this.workspaceUserRepo
      .createQueryBuilder('workspaceUser')
      .select([
        'workspaceUser.id',
        'workspaceUser.createdAt',
        'user.id',
        'workspace.id',
        'workspaceUser.workspaceRole',
        'owner.id',
      ])
      .innerJoin('workspaceUser.user', 'user')
      .innerJoin('workspaceUser.workspace', 'workspace')
      .innerJoin('workspace.owner', 'owner')
      .where('user.id = :userId', { userId })
      .getMany();
  }
}
