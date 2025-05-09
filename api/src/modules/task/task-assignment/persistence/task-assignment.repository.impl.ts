import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProgressStatus } from '../../task-module/domain/progress-status.enum';
import { TaskAssignmentEntity } from './task-assignment.entity';
import { TaskAssignmentRepository } from './task-assignment.repository';

@Injectable()
export class TaskAssignmentRepositoryImpl implements TaskAssignmentRepository {
  constructor(
    @InjectRepository(TaskAssignmentEntity)
    private readonly repo: Repository<TaskAssignmentEntity>,
  ) {}

  async findyAllByAssigneeIdAndWorkspaceIdAndStatus({
    workspaceUserId,
    workspaceId,
    status,
  }: {
    workspaceUserId: string;
    workspaceId: string;
    status: ProgressStatus;
  }): Promise<TaskAssignmentEntity[]> {
    return await this.repo.find({
      where: {
        assignee: {
          id: workspaceUserId,
        },
        task: {
          workspace: {
            id: workspaceId,
          },
        },
        status,
      },
      relations: {
        assignee: true,
        task: {
          workspace: true,
        },
      },
    });
  }
}
