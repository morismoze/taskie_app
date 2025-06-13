import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
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
    await this.repo.update(id, data);

    const newEntity = await this.findById({ id, relations });

    return newEntity;
  }
}
