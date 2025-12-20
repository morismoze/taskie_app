import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { TransactionalRepository } from 'src/modules/unit-of-work/persistence/transactional.repository';
import { FindOptionsRelations, In, Repository } from 'typeorm';
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
    const persistenceModel = this.repo.create({
      assignee: {
        id: workspaceUserId,
      },
      task: {
        id: taskId,
      },
      status,
    });

    const savedEntity =
      await this.transactionalTaskAssignmentRepo.save(persistenceModel);

    const newEntity = await this.transactionalTaskAssignmentRepo.findOne({
      where: { id: savedEntity.id },
      relations,
    });

    return newEntity;
  }

  async createMultiple({
    workspaceUserIds,
    taskId,
    status,
    relations,
  }: {
    workspaceUserIds: Array<TaskAssignment['assignee']['id']>;
    taskId: TaskAssignment['task']['id'];
    status: TaskAssignment['status'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Array<TaskAssignmentEntity>> {
    const persistenceModel = this.repo.create(
      workspaceUserIds.map((id) => ({
        assignee: {
          id,
        },
        task: {
          id: taskId,
        },
        status,
      })),
    );

    const savedEntities =
      await this.transactionalTaskAssignmentRepo.save(persistenceModel);
    const savedEntitiesIds = savedEntities.map((entity) => entity.id);

    const newEntity = await this.transactionalTaskAssignmentRepo.find({
      where: { id: In(savedEntitiesIds) },
      relations,
    });

    return newEntity;
  }

  async findById({
    id,
    relations,
  }: {
    id: TaskAssignment['id'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>> {
    return await this.repo.findOne({
      where: { id },
      relations,
    });
  }

  async findAllByTaskId({
    taskId,
    relations,
  }: {
    taskId: TaskAssignment['task']['id'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<TaskAssignmentEntity[]> {
    return await this.repo.find({
      where: { task: { id: taskId } },
      relations,
    });
  }

  async findAllByTaskIdAndAssigneeId({
    taskId,
    assigneeIds,
    relations,
  }: {
    taskId: TaskAssignment['task']['id'];
    assigneeIds: Array<TaskAssignment['assignee']['id']>;
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<TaskAssignmentEntity[]> {
    return await this.repo.find({
      where: { task: { id: taskId }, assignee: { id: In(assigneeIds) } },
      relations,
    });
  }

  async findByIdWithAssigneeUser({
    id,
    relations,
  }: {
    id: TaskAssignment['id'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>> {
    return await this.repo.findOne({
      where: { id },
      relations,
    });
  }

  async findByTaskId({
    id,
    relations,
  }: {
    id: TaskAssignment['task']['id'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>> {
    return await this.repo.findOne({
      where: { task: { id } },
      relations,
    });
  }

  async findyAllByAssigneeIdAndWorkspaceIdAndStatus({
    workspaceUserId,
    workspaceId,
    status,
  }: {
    workspaceUserId: TaskAssignment['assignee']['id'];
    workspaceId: TaskAssignment['task']['workspace']['id'];
    status: TaskAssignment['status'];
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

  async update({
    id,
    data,
    relations,
  }: {
    id: TaskAssignment['id'];
    data: Partial<TaskAssignmentCore>;
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>> {
    await this.transactionalTaskAssignmentRepo.update(id, data);

    const newEntity = await this.transactionalTaskAssignmentRepo.findOne({
      where: { id },
      relations,
    });

    return newEntity;
  }

  async deleteByTaskIdAndAssigneeIds({
    taskId,
    assigneeIds,
  }: {
    taskId: TaskAssignment['task']['id'];
    assigneeIds: Array<TaskAssignment['assignee']['id']>;
  }): Promise<void> {
    this.transactionalTaskAssignmentRepo.delete({
      task: { id: taskId },
      assignee: { id: In(assigneeIds) },
    });
  }

  private get transactionalTaskAssignmentRepo(): Repository<TaskAssignmentEntity> {
    return this.transactionalRepository.getRepository(TaskAssignmentEntity);
  }
}
