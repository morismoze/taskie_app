import { Nullable } from 'src/common/types/nullable.type';
import { WorkspaceUser } from '../../workspace-user-module/domain/workspace-user.domain';
import { Workspace } from '../domain/workspace.domain';

export abstract class WorkspaceRepository {
  abstract create(
    data: Pick<Workspace, 'name' | 'description' | 'pictureUrl' | 'ownedBy'>,
  ): Promise<Nullable<Workspace>>;

  abstract findById(id: Workspace['id']): Promise<Nullable<Workspace>>;

  abstract findAllByUserId(
    userId: WorkspaceUser['user']['id'],
  ): Promise<Workspace[]>;
}
