import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { TransactionalRepository } from 'src/modules/unit-of-work/persistence/transactional.repository';
import { Workspace } from 'src/modules/workspace/workspace-module/domain/workspace.domain';
import { FindOptionsRelations, In, Repository } from 'typeorm';
import { ProgressStatus } from '../../task-module/domain/progress-status.enum';
import { TaskAssignmentCore } from '../domain/task-assignment-core.domain';
import { TaskAssignment } from '../domain/task-assignment.domain';
import { TaskAssignmentEntity } from './task-assignment.entity';
import { TaskAssignmentRepository } from './task-assignment.repository';

@Injectable()
export class TaskAssignmentRepositoryImpl implements TaskAssignmentRepository {
  constructor(
    @InjectRepository(TaskAssignmentEntity)
    private readonly repo: Repository<TaskAssignmentEntity>,
    private readonly transactionalRepository: TransactionalRepository,
  ) {}

  private get repositoryContext(): Repository<TaskAssignmentEntity> {
    const transactional =
      this.transactionalRepository.getRepository(TaskAssignmentEntity);

    // If there is a transactional repo available (a transaction bound to the
    // request is available), use it. Otherwise, use normal repo.
    return transactional || this.repo;
  }

  async sumPointsByAssignee({
    workspaceUserId,
    workspaceId,
  }: {
    workspaceUserId: TaskAssignment['assignee']['id'];
    workspaceId: Workspace['id'];
  }): Promise<number> {
    const result = await this.repositoryContext
      .createQueryBuilder('assignment')
      .leftJoin('assignment.task', 'task')
      .select('SUM(task.rewardPoints)', 'total')
      .where('assignment.assignee = :workspaceUserId', { workspaceUserId })
      .andWhere('task.workspace = :workspaceId', { workspaceId })
      .andWhere('assignment.status = :status', {
        status: ProgressStatus.COMPLETED,
      })
      .getRawOne();

    return result.total ? parseInt(result.total, 10) : 0;
  }

  async create({
    workspaceUserId,
    taskId,
    status,
    relations,
  }: {
    workspaceUserId: TaskAssignment['assignee']['id'];
    taskId: TaskAssignment['task']['id'];
    status: TaskAssignment['status'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>> {
    const persistenceModel = this.repositoryContext.create({
      assignee: {
        id: workspaceUserId,
      },
      task: {
        id: taskId,
      },
      status,
    });

    const savedEntity = await this.repositoryContext.save(persistenceModel);

    const newEntity = await this.repositoryContext.findOne({
      where: { id: savedEntity.id },
      relations,
    });

    return newEntity;
  }

  async createMultiple({
    assignments,
    taskId,
    relations,
  }: {
    assignments: Array<{
      workspaceUserId: TaskAssignment['assignee']['id'];
      status: TaskAssignment['status'];
    }>;
    taskId: TaskAssignment['task']['id'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Array<TaskAssignmentEntity>> {
    const persistenceModel = this.repositoryContext.create(
      assignments.map((assignment) => ({
        assignee: {
          id: assignment.workspaceUserId,
        },
        task: {
          id: taskId,
        },
        status: assignment.status,
      })),
    );

    const savedEntities = await this.repositoryContext.save(persistenceModel);
    const savedEntitiesIds = savedEntities.map((entity) => entity.id);

    const newEntity = await this.repositoryContext.find({
      where: { id: In(savedEntitiesIds) },
      relations,
    });

    return newEntity;
  }

  findById({
    id,
    relations,
  }: {
    id: TaskAssignment['id'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>> {
    return this.repositoryContext.findOne({
      where: { id },
      relations,
    });
  }

  findAllByTaskId({
    taskId,
    relations,
  }: {
    taskId: TaskAssignment['task']['id'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<TaskAssignmentEntity[]> {
    return this.repositoryContext.find({
      where: { task: { id: taskId } },
      relations,
    });
  }

  findAllByTaskIdAndAssigneeIds({
    taskId,
    assigneeIds,
    relations,
  }: {
    taskId: TaskAssignment['task']['id'];
    assigneeIds: Array<TaskAssignment['assignee']['id']>;
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<TaskAssignmentEntity[]> {
    return this.repositoryContext.find({
      where: { task: { id: taskId }, assignee: { id: In(assigneeIds) } },
      relations,
    });
  }

  findAllByAssigneeIdAndWorkspaceIdAndStatus({
    workspaceUserId,
    workspaceId,
    status,
  }: {
    workspaceUserId: TaskAssignment['assignee']['id'];
    workspaceId: TaskAssignment['task']['workspace']['id'];
    status: TaskAssignment['status'];
  }): Promise<TaskAssignmentEntity[]> {
    return this.repositoryContext.find({
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

  async update({
    id,
    data,
    relations,
  }: {
    id: TaskAssignment['id'];
    data: Partial<TaskAssignmentCore>;
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>> {
    const result = await this.repositoryContext.update(id, data);

    // Early return - provided ID does not exist
    if (result.affected === 0) {
      return null;
    }

    const newEntity = await this.repositoryContext.findOne({
      where: { id },
      relations,
    });

    return newEntity;
  }

  async updateAllByTaskId({
    taskId,
    data,
    relations,
  }: {
    taskId: TaskAssignment['task']['id'];
    data: Partial<TaskAssignmentCore>;
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity[]>> {
    const result = await this.repositoryContext.update(
      { task: { id: taskId } },
      data,
    );

    // Early return - provided ID does not exist
    if (result.affected === 0) {
      return null;
    }

    const newEntity = await this.repositoryContext.find({
      where: { task: { id: taskId } },
      relations,
    });

    return newEntity;
  }

  async countByTaskId(id: TaskAssignment['task']['id']): Promise<number> {
    return this.repositoryContext.countBy({ task: { id } });
  }

  async deleteByTaskIdAndAssigneeIds({
    taskId,
    assigneeIds,
  }: {
    taskId: TaskAssignment['task']['id'];
    assigneeIds: Array<TaskAssignment['assignee']['id']>;
  }): Promise<boolean> {
    const result = await this.repositoryContext.delete({
      task: { id: taskId },
      assignee: { id: In(assigneeIds) },
    });
    return (result.affected ?? 0) > 0;
  }
}
