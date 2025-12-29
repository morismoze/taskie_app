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

  async findByIdAndWorkspaceId({
    id,
    workspaceId,
    relations,
  }: {
    id: WorkspaceUser['id'];
    workspaceId: WorkspaceUser['workspace']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>> {
    return await this.repo.findOne({
      where: { id, workspace: { id: workspaceId } },
      relations,
    });
  }

  async findByUserIdAndWorkspaceId({
    userId,
    workspaceId,
    relations,
  }: {
    userId: WorkspaceUser['user']['id'];
    workspaceId: WorkspaceUser['workspace']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>> {
    return await this.repo.findOne({
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
    return await this.repo.find({
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
    return await this.repo.find({
      where: {
        user: {
          id: userId,
        },
      },
      relations,
    });
  }

  async findAllByIds({
    workspaceId,
    ids,
    relations,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    ids: WorkspaceUser['id'][];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<WorkspaceUserEntity[]> {
    return this.repo.find({
      where: {
        id: In(ids),
        workspace: { id: workspaceId },
      },
      relations,
    });
  }

  async findAllByWorkspaceId({
    workspaceId,
    relations,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<WorkspaceUserEntity[]> {
    return this.repo.find({
      where: {
        workspace: { id: workspaceId },
      },
      relations,
    });
  }

  async create({
    data: { workspaceId, createdById, userId, workspaceRole, status },
    relations,
  }: {
    data: {
      workspaceId: WorkspaceUser['workspace']['id'];
      createdById: WorkspaceUser['id'] | null;
      userId: WorkspaceUser['user']['id'];
      workspaceRole: WorkspaceUser['workspaceRole'];
      status: WorkspaceUser['status'];
    };
    relations?: FindOptionsRelations<WorkspaceUserEntity>;
  }): Promise<Nullable<WorkspaceUserEntity>> {
    const persistenceModel = this.repo.create({
      workspace: { id: workspaceId },
      user: { id: userId },
      workspaceRole,
      status,
      createdBy: createdById ? { id: createdById } : null,
    });

    const savedEntity =
      await this.transactionalWorkspaceUserRepo.save(persistenceModel);

    const newEntity = await this.transactionalWorkspaceUserRepo.findOne({
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
    await this.transactionalWorkspaceUserRepo.update(id, data);

    const updatedEntity = await this.transactionalWorkspaceUserRepo.findOne({
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
  }): Promise<void> {
    await this.repo.delete({
      id: workspaceUserId,
      workspace: { id: workspaceId },
    });
  }

  async getWorkspaceUserAccumulatedPoints({
    workspaceId,
    workspaceUserId,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    workspaceUserId;
  }): Promise<Nullable<number>> {
    const result = await this.repo
      .createQueryBuilder('wu')
      // Take only completed tasks into context
      .leftJoin('wu.taskAssignments', 'ta', 'ta.status = :completedStatus', {
        completedStatus: ProgressStatus.COMPLETED,
      })
      .leftJoin('ta.task', 't')
      .select(['COALESCE(SUM(t.rewardPoints), 0) AS "accumulatedPoints"'])
      .where('wu.workspace.id = :workspaceId', { workspaceId })
      .andWhere('wu.id = :workspaceUserId', {
        workspaceUserId,
      })
      .groupBy('wu.id')
      .getRawOne();

    if (result === undefined) {
      return null;
    }

    return parseInt(result.accumulatedPoints);
  }

  async getWorkspaceLeaderboard(
    workspaceId: WorkspaceUser['workspace']['id'],
  ): Promise<Array<WorkspaceUserAccumulatedPoints>> {
    return (
      this.repo
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
        .getRawMany()
    );
  }

  private get transactionalWorkspaceUserRepo(): Repository<WorkspaceUserEntity> {
    return this.transactionalRepository.getRepository(WorkspaceUserEntity);
  }
}
