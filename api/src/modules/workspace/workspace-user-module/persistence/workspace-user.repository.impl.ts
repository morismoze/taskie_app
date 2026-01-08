import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { TransactionalRepository } from 'src/modules/unit-of-work/persistence/transactional.repository';
import { FindOptionsRelations, In, Repository } from 'typeorm';
import { WorkspaceUserCore } from '../domain/workspace-user-core.domain';
import { WorkspaceUserRole } from '../domain/workspace-user-role.enum';
import { WorkspaceUser } from '../domain/workspace-user.domain';
import { WorkspaceUserEntity } from './workspace-user.entity';
import {
  WorkspaceUserAccumulatedPoints,
  WorkspaceUserRepository,
} from './workspace-user.repository';

@Injectable()
export class WorkspaceUserRepositoryImpl implements WorkspaceUserRepository {
  constructor(
    @InjectRepository(WorkspaceUserEntity)
    private readonly repo: Repository<WorkspaceUserEntity>,
    private readonly transactionalRepository: TransactionalRepository,
  ) {}

  private get repositoryContext(): Repository<WorkspaceUserEntity> {
    const transactional =
      this.transactionalRepository.getRepository(WorkspaceUserEntity);

    // If there is a transactional repo available (a transaction bound to the
    // request is available), use it. Otherwise, use normal repo.
    return transactional || this.repo;
  }

  async findByIdAndWorkspaceId({
    id,
    workspaceId,
    relations,
  }: {
    id: WorkspaceUser['id'];
    workspaceId: WorkspaceUser['workspace']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>> {
    return await this.repositoryContext.findOne({
      where: { id, workspace: { id: workspaceId } },
      relations,
    });
  }

  findByUserIdAndWorkspaceId({
    userId,
    workspaceId,
    relations,
  }: {
    userId: WorkspaceUser['user']['id'];
    workspaceId: WorkspaceUser['workspace']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>> {
    return this.repositoryContext.findOne({
      where: { user: { id: userId }, workspace: { id: workspaceId } },
      relations,
    });
  }

  async findByIdsAndWorkspaceId({
    ids,
    workspaceId,
    relations,
  }: {
    ids: Array<WorkspaceUser['user']['id']>;
    workspaceId: WorkspaceUser['workspace']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Array<WorkspaceUserEntity>> {
    return this.repositoryContext.find({
      where: { id: In(ids), workspace: { id: workspaceId } },
      relations,
    });
  }

  async findAllByUserId({
    userId,
    relations,
  }: {
    userId: WorkspaceUser['user']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<WorkspaceUserEntity[]> {
    return this.repositoryContext.find({
      where: {
        user: {
          id: userId,
        },
      },
      relations,
    });
  }

  findAllByIds({
    workspaceId,
    ids,
    relations,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    ids: WorkspaceUser['id'][];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<WorkspaceUserEntity[]> {
    return this.repositoryContext.find({
      where: {
        id: In(ids),
        workspace: { id: workspaceId },
      },
      relations,
    });
  }

  findAllByWorkspaceId({
    workspaceId,
    relations,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<WorkspaceUserEntity[]> {
    return this.repositoryContext.find({
      where: {
        workspace: { id: workspaceId },
      },
      relations,
    });
  }

  async countManagers({
    workspaceId,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
  }): Promise<number> {
    return this.repositoryContext.count({
      where: {
        workspace: { id: workspaceId },
        workspaceRole: WorkspaceUserRole.MANAGER,
      },
    });
  }

  async create({
    data: { workspaceId, createdById, userId, workspaceRole },
    relations,
  }: {
    data: {
      workspaceId: WorkspaceUser['workspace']['id'];
      createdById: WorkspaceUser['id'] | null;
      userId: WorkspaceUser['user']['id'];
      workspaceRole: WorkspaceUser['workspaceRole'];
    };
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>> {
    const persistenceModel = this.repositoryContext.create({
      workspace: { id: workspaceId },
      user: { id: userId },
      workspaceRole,
      createdBy: createdById ? { id: createdById } : null,
    });

    const savedEntity = await this.repositoryContext.save(persistenceModel);

    const newEntity = await this.repositoryContext.findOne({
      where: { id: savedEntity.id },
      relations,
    });

    return newEntity;
  }

  async update({
    id,
    data,
    relations,
  }: {
    id: WorkspaceUser['id'];
    data: Partial<WorkspaceUserCore>;
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>> {
    const result = await this.repositoryContext.update(id, data);

    // Early return - provided ID does not exist
    if (result.affected === 0) {
      return null;
    }

    const updatedEntity = await this.repositoryContext.findOne({
      where: { id },
      relations,
    });

    return updatedEntity;
  }

  async delete({
    workspaceId,
    workspaceUserId,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    workspaceUserId: WorkspaceUser['user']['id'];
  }): Promise<boolean> {
    const result = await this.repositoryContext.delete({
      id: workspaceUserId,
      workspace: { id: workspaceId },
    });
    return (result.affected ?? 0) > 0;
  }

  async getWorkspaceLeaderboard(
    workspaceId: WorkspaceUser['workspace']['id'],
  ): Promise<Array<WorkspaceUserAccumulatedPoints>> {
    const rawResults = await this.repositoryContext
      .createQueryBuilder('wu')
      .leftJoin('wu.user', 'u')
      // Leaderboard takes only completed tasks into context
      .leftJoin('wu.taskAssignments', 'ta', 'ta.status = :completedStatus', {
        completedStatus: ProgressStatus.COMPLETED,
      })
      .leftJoin('ta.task', 't')
      .select([
        'wu.id AS "id"',
        'u.firstName AS "firstName"',
        'u.lastName AS "lastName"',
        'u.profileImageUrl AS "profileImageUrl"',
        'COALESCE(SUM(t.rewardPoints), 0) AS "accumulatedPoints"',
        'COUNT(ta.id) AS "completedTasks"',
      ])
      .where('wu.workspace.id = :workspaceId', { workspaceId })
      .andWhere('wu.workspaceRole = :memberRole', {
        memberRole: WorkspaceUserRole.MEMBER,
      })
      .groupBy('wu.id, u.firstName, u.lastName, u.profileImageUrl')
      // Leaderboard starts with the best score
      .orderBy('"accumulatedPoints"', 'DESC')
      .addOrderBy('"completedTasks"', 'DESC')
      .addOrderBy('u.firstName', 'ASC')
      .addOrderBy('u.lastName', 'ASC')
      // This returns raw data as defined in the SQL query itself. Function getMany on the other hand
      // returns data and tries to build the array of entity type records (WorkspaceUser[] in this case)
      // TODO: check if accumulatedPoints and completedTasks are numbers in the response and not strings
      .getRawMany();

    return rawResults.map((row) => ({
      id: row.id,
      firstName: row.firstName,
      lastName: row.lastName,
      profileImageUrl: row.profileImageUrl,
      // Postgres vraća bigint/sum kao string da ne izgubi preciznost,
      // ali za bodove je JS number (max 9 quadrilijuna) sasvim dovoljan.
      accumulatedPoints: parseInt(row.accumulatedPoints, 10),
      completedTasks: parseInt(row.completedTasks, 10),
    }));
  }
}
