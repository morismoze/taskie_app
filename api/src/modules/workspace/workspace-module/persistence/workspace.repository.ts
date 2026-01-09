import { Nullable } from 'src/common/types/nullable.type';
import { User } from 'src/modules/user/domain/user.domain';
import { FindOptionsRelations } from 'typeorm';
import { WorkspaceUser } from '../../workspace-user-module/domain/workspace-user.domain';
import { WorkspaceCore } from '../domain/workspace-core.domain';
import { Workspace } from '../domain/workspace.domain';
import { WorkspaceEntity } from './workspace.entity';

export abstract class WorkspaceRepository {
  abstract create(args: {
    data: {
      name: Workspace['name'];
      description: Workspace['description'];
      pictureUrl: Workspace['pictureUrl'];
    };
    createdById: User['id'];
    relations?: FindOptionsRelations<WorkspaceEntity>;
  }): Promise<Nullable<WorkspaceEntity>>;

  abstract update(args: {
    id: Workspace['id'];
    data: Partial<WorkspaceCore>;
    relations?: FindOptionsRelations<WorkspaceEntity>;
  }): Promise<Nullable<WorkspaceEntity>>;

  abstract findById(args: {
    id: Workspace['id'];
    relations?: FindOptionsRelations<WorkspaceEntity>;
  }): Promise<Nullable<WorkspaceEntity>>;

  abstract findAllByUserId(args: {
    userId: WorkspaceUser['user']['id'];
    relations?: FindOptionsRelations<WorkspaceEntity>;
  }): Promise<WorkspaceEntity[]>;

  abstract deleteById(id: Workspace['id']): Promise<boolean>;
}
