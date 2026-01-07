import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { SortBy } from 'src/modules/workspace/workspace-module/dto/request/workspace-objective-request-query.dto';
import { WorkspaceUser } from 'src/modules/workspace/workspace-user-module/domain/workspace-user.domain';
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

  async create({
    data,
    workspaceId,
    createdById,
    relations,
  }: {
    data: {
      title: Goal['title'];
      description: Goal['description'];
      requiredPoints: Goal['requiredPoints'];
      assigneeId: Goal['assignee']['id'];
    };
    workspaceId: Goal['workspace']['id'];
    createdById: WorkspaceUser['id'];
    relations?: FindOptionsRelations<GoalEntity>;
  }): Promise<Nullable<GoalEntity>> {
    const persistenceModel = this.repo.create({
      workspace: {
        id: workspaceId,
      },
      title: data.title,
      description: data.description,
      requiredPoints: data.requiredPoints,
      assignee: { id: data.assigneeId },
      createdBy: { id: createdById },
    });

    const savedEntity = await this.repo.save(persistenceModel);

    const newEntity = await this.findById({
      id: savedEntity.id,
      relations,
    });

    return newEntity;
  }

  async findById({
    id,
    relations,
  }: {
    id: Goal['id'];
    relations?: FindOptionsRelations<GoalEntity>;
  }): Promise<Nullable<GoalEntity>> {
    return await this.repo.findOne({
      where: { id },
      relations,
    });
  }

  async findByGoalIdAndWorkspaceId({
    goalId,
    workspaceId,
    relations,
  }: {
    goalId: Goal['id'];
    workspaceId: Goal['workspace']['id'];
    relations?: FindOptionsRelations<GoalEntity>;
  }): Promise<Nullable<GoalEntity>> {
    return await this.repo.findOne({
      where: { id: goalId, workspace: { id: workspaceId } },
      relations,
    });
  }

  async findAllByWorkspaceId({
    workspaceId,
    query: { page, limit, sort, status, search },
    relations,
  }: {
    workspaceId: Goal['workspace']['id'];
    query: {
      page: number;
      limit: number;
      sort: SortBy;
      status: ProgressStatus | null;
      search: string | null;
    };
    relations?: FindOptionsRelations<GoalEntity>;
  }): Promise<{
    data: GoalEntity[];
    totalPages: number;
    total: number;
  }> {
    const offset = (page - 1) * limit;

    const findOptions: FindManyOptions<GoalEntity> = {
      where: { workspace: { id: workspaceId } },
      skip: offset,
      take: limit,
      relations,
    };

    if (status) {
      findOptions.where = {
        ...findOptions.where,
        status,
      };
    }

    if (search) {
      // Escape special characters used in SQL LIKE/ILIKE
      // 1. Escape backslash first
      // 2. Escape percent sign
      // 3. Escape underscore
      // E.g. ILIKE '%%%' - this would return all the goals
      // which, if there are many goals, would fill up RAM
      // and possibly fail the server.
      const sanitizedSearch = search
        .replace(/\\/g, '\\\\')
        .replace(/%/g, '\\%')
        .replace(/_/g, '\\_');

      findOptions.where = {
        ...findOptions.where,
        title: ILike(`%${sanitizedSearch}%`),
      };
    }

    switch (sort) {
      case SortBy.NEWEST:
        findOptions.order = { createdAt: 'DESC' };
        break;
      case SortBy.OLDEST:
        findOptions.order = { createdAt: 'ASC' };
        break;
    }

    const [goalEntities, totalCount] =
      await this.repo.findAndCount(findOptions);

    return {
      data: goalEntities,
      totalPages: Math.ceil(totalCount / limit),
      total: totalCount,
    };
  }

  async update({
    id,
    data,
    relations,
  }: {
    id: Goal['id'];
    data: Partial<
      Omit<
        Goal,
        'id' | 'createdAt' | 'updatedAt' | 'deletedAt' | 'assignee'
      > & { assigneeId: Goal['assignee']['id'] }
    >;
    relations?: FindOptionsRelations<GoalEntity>;
  }): Promise<Nullable<GoalEntity>> {
    const { assigneeId, ...restData } = data;
    const updateData: any = { ...restData };

    if (data.assigneeId) {
      updateData.assignee = {
        id: data.assigneeId,
      };
    }

    const result = await this.repo.update(id, updateData);

    // Early return - provided ID does not exist
    if (result.affected === 0) {
      return null;
    }

    const newEntity = await this.findById({ id, relations });

    return newEntity;
  }
}
