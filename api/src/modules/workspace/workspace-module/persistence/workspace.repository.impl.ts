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
    const persistenceModel = this.repo.create({
      name,
      description,
      pictureUrl,
      createdBy: { id: createdById },
    });

    const savedEntity =
      await this.transactionalWorkspaceRepo.save(persistenceModel);

    const newEntity = await this.transactionalWorkspaceRepo.findOne({
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
    await this.repo.update(id, data);

    const updatedEntity = await this.repo.findOne({
      where: { id },
      relations,
    });

    return updatedEntity;
  }

  async findById({
    id,
    relations,
  }: {
    id: Workspace['id'];
    relations?: FindOptionsRelations<WorkspaceEntity>;
  }): Promise<Nullable<WorkspaceEntity>> {
    return await this.repo.findOne({
      where: { id },
      relations,
    });
  }

  async findAllByUserId({
    userId,
    relations,
  }: {
    userId: WorkspaceUser['user']['id'];
    relations?: FindOptionsRelations<WorkspaceEntity>;
  }): Promise<WorkspaceEntity[]> {
    return await this.repo.find({
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

  private get transactionalWorkspaceRepo(): Repository<WorkspaceEntity> {
    return this.transactionalRepository.getRepository(WorkspaceEntity);
  }
}
