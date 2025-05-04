import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProgressStatus } from '../domain/progress-status.enum';
import { TaskEntity } from './task.entity';
import { TaskRepository } from './task.repository';

@Injectable()
export class TaskRepositoryImpl implements TaskRepository {
  constructor(
    @InjectRepository(TaskEntity)
    private readonly repo: Repository<TaskEntity>,
  ) {}

  async findTasksWithAssigneesForWorkspace(
    workspaceId: string,
    {
      page,
      limit,
      status,
      search,
    }: {
      page: number;
      limit: number;
      status?: ProgressStatus;
      search?: string;
    },
  ): Promise<{ data: TaskEntity[]; total: number }> {
    const offset = (page - 1) * limit;

    const qb = this.repo
      .createQueryBuilder('task')
      .leftJoinAndSelect('task.taskAssignments', 'assignment')
      .leftJoinAndSelect('assignment.assignee', 'assignee')
      .leftJoinAndSelect('assignee.user', 'user')
      .where('task.workspace.id = :workspaceId', { workspaceId });

    if (status) {
      qb.andWhere('assignment.status = :status', { status });
    }

    if (search) {
      qb.andWhere('LOWER(task.title) LIKE :search', {
        search: `%${search.toLowerCase()}%`,
      });
    }

    qb.skip(offset).take(limit);

    const [taskEntities, totalCount] = await qb.getManyAndCount();

    return {
      data: taskEntities,
      total: totalCount,
    };
  }
}
