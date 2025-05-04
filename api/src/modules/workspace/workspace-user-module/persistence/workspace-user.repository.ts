import { Nullable } from 'src/common/types/nullable.type';
import { WorkspaceUser } from '../domain/workspace-user.domain';

export abstract class WorkspaceUserRepository {
  abstract findByUserId(
    userId: WorkspaceUser['user']['id'],
  ): Promise<Nullable<WorkspaceUser>>;

  abstract findAllByUserId(
    userId: WorkspaceUser['user']['id'],
  ): Promise<WorkspaceUser[]>;

  abstract create(data: {
    workspaceId: WorkspaceUser['workspace']['id'];
    userId: WorkspaceUser['user']['id'];
    workspaceRole: WorkspaceUser['workspaceRole'];
    status: WorkspaceUser['status'];
    createdById: WorkspaceUser['id'] | null;
  }): Promise<Nullable<WorkspaceUser>>;
}
