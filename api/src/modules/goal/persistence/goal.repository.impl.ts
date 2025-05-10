import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import {
  FindManyOptions,
  FindOptionsRelations,
  ILike,
  Repository,
} from 'typeorm';
import { Goal } from '../domain/goal.domain';
import { GoalEntity } from './goal.entity';
import { GoalRepository } from './goal.repository';

@Injectable()
export class GoalRepositoryImpl implements GoalRepository {
  constructor(
    @InjectRepository(GoalEntity)
    private readonly repo: Repository<GoalEntity>,
  ) {}

  async findAllByWorkspaceId({
    workspaceId,
    query: { page, limit, status, search },
    relations,
  }: {
    workspaceId: Goal['workspace']['id'];
    query: {
      page: number;
      limit: number;
      status: ProgressStatus;
      search: string | null;
    };
    relations?: FindOptionsRelations<GoalEntity>;
  }): Promise<{
    data: GoalEntity[];
    total: number;
  }> {
    const offset = (page - 1) * limit;

    const findOptions: FindManyOptions<GoalEntity> = {
      where: { workspace: { id: workspaceId }, status },
      skip: offset,
      take: limit,
      relations,
    };

    if (search) {
      findOptions.where = {
        ...findOptions.where,
        title: ILike(`%${search}%`),
      };
    }

    const [goalEntities, totalCount] =
      await this.repo.findAndCount(findOptions);

    return {
      data: goalEntities,
      total: totalCount,
    };
  }
}
