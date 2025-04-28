import { Nullable } from 'src/common/types/nullable.type';
import { WorkspaceUser } from '../domain/workspace-user.domain';

export abstract class WorkspaceUserRepository {
  abstract findByUserId(
    userId: WorkspaceUser['user']['id'],
  ): Promise<Nullable<WorkspaceUser>>;

  abstract findAllByUserId(
    userId: WorkspaceUser['user']['id'],
  ): Promise<WorkspaceUser[]>;

  abstract create(
    data: Omit<WorkspaceUser, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>,
  ): Promise<Nullable<WorkspaceUser>>;
}
