import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations, LessThan, Repository } from 'typeorm';
import { WorkspaceInvite } from '../domain/workspace-invite.domain';
import { WorkspaceInviteEntity } from './workspace-invite.entity';
import { WorkspaceInviteRepository } from './workspace-invite.repository';

@Injectable()
export class WorkspaceInviteRepositoryImpl
  implements WorkspaceInviteRepository
{
  constructor(
    @InjectRepository(WorkspaceInviteEntity)
    private readonly repo: Repository<WorkspaceInviteEntity>,
  ) {}

  async findById({
    id,
    relations,
  }: {
    id: WorkspaceInvite['id'];
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>> {
    return await this.repo.findOne({
      where: { id },
      relations,
    });
  }

  async findByToken({
    token,
    relations,
  }: {
    token: WorkspaceInvite['token'];
    relations?: FindOptionsRelations<WorkspaceInviteEntity>;
  }): Promise<Nullable<WorkspaceInviteEntity>> {
    return await this.repo.findOne({
      where: { token },
      relations,
    });
  }

  async deleteExpiredInvites(): Promise<void> {
    const now = new Date();
    await this.repo.delete({
      expiresAt: LessThan(now),
    });
  }
}
