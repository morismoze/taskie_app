import { WorkspaceUser } from '../domain/workspace-user.domain';
import { WorkspaceUserEntity } from './workspace-user.entity';

export class WorkspaceUserMapper {
  static toDomain(entity: WorkspaceUserEntity): WorkspaceUser {
    return {
      id: entity.id,
      createdAt: entity.createdAt,
      user: {
        id: entity.user.id,
      },
      workspace: {
        id: entity.workspace.id,
        name: entity.workspace.name,
      },
      role: entity.workspaceRole,
      status: entity.status,
    };
  }
}
