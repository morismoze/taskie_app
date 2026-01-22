import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { TransactionalRepository } from 'src/modules/unit-of-work/persistence/transactional.repository';
import { User } from 'src/modules/user/domain/user.domain';
import { FindOptionsRelations, Repository } from 'typeorm';
import { WorkspaceUser } from '../../workspace-user-module/domain/workspace-user.domain';
import { WorkspaceCore } from '../domain/workspace-core.domain';
import { Workspace } from '../domain/workspace.domain';
import { WorkspaceEntity } from './workspace.entity';
import { WorkspaceRepository } from './workspace.repository';

@Injectable()
export class WorkspaceRepositoryImpl implements WorkspaceRepository {
  constructor(
    @InjectRepository(WorkspaceEntity)
    private readonly repo: Repository<WorkspaceEntity>,
    private readonly transactionalRepository: TransactionalRepository,
  ) {}

  private get repositoryContext(): Repository<WorkspaceEntity> {
    const transactional =
      this.transactionalRepository.getRepository(WorkspaceEntity);

    // If there is a transactional repo available (a transaction bound to the
    // request is available), use it. Otherwise, use normal repo.
    return transactional || this.repo;
  }

  async create({
    data: { name, description, pictureUrl },
    createdById,
    relations,
  }: {
    data: {
      name: Workspace['name'];
      description: Workspace['description'];
      pictureUrl: Workspace['pictureUrl'];
    };
    createdById: User['id'];
    relations?: FindOptionsRelations<WorkspaceEntity>;
  }): Promise<Nullable<WorkspaceEntity>> {
    const persistenceModel = this.repositoryContext.create({
      name,
      description,
      pictureUrl,
      createdBy: { id: createdById },
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
    id: Workspace['id'];
    data: Partial<WorkspaceCore>;
    relations?: FindOptionsRelations<WorkspaceEntity>;
  }): Promise<Nullable<WorkspaceEntity>> {
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

  findById({
    id,
    relations,
  }: {
    id: Workspace['id'];
    relations?: FindOptionsRelations<WorkspaceEntity>;
  }): Promise<Nullable<WorkspaceEntity>> {
    return this.repositoryContext.findOne({
      where: { id },
      relations,
    });
  }

  findAllByUserId({
    userId,
    relations,
  }: {
    userId: WorkspaceUser['user']['id'];
    relations?: FindOptionsRelations<WorkspaceEntity>;
  }): Promise<WorkspaceEntity[]> {
    return this.repositoryContext.find({
      where: {
        members: {
          user: {
            id: userId,
          },
        },
      },
      relations,
    });
  }

  async delete(id: Workspace['id']): Promise<boolean> {
    const result = await this.repositoryContext.delete(id);
    return (result.affected ?? 0) > 0;
  }
}
