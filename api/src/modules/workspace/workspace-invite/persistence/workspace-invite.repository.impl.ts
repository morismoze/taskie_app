import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
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
}
