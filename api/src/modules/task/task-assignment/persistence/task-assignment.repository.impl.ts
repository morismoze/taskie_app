import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations, Repository } from 'typeorm';
import { TaskAssignment } from '../domain/task-assignment.domain';
import { TaskAssignmentEntity } from './task-assignment.entity';
import { TaskAssignmentRepository } from './task-assignment.repository';

@Injectable()
export class TaskAssignmentRepositoryImpl implements TaskAssignmentRepository {
  constructor(
    @InjectRepository(TaskAssignmentEntity)
    private readonly repo: Repository<TaskAssignmentEntity>,
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
    id: TaskAssignment['id'];
    relations?: FindOptionsRelations<TaskAssignmentEntity>;
  }): Promise<Nullable<TaskAssignmentEntity>> {
    return await this.repo.findOne({
      where: { id },
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
}
