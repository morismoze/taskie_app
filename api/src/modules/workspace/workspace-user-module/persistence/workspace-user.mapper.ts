import { UserMapper } from 'src/modules/user/persistence/user.mapper';
import { WorkspaceMapper } from '../../workspace-module/persistence/workspace.mapper';
import { WorkspaceUser } from '../domain/workspace-user.domain';
import { WorkspaceUserEntity } from './workspace-user.entity';

export class WorkspaceUserMapper {
  static toDomain(entity: WorkspaceUserEntity): WorkspaceUser {
    return {
      id: entity.id,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      user: UserMapper.toDomain(entity.user),
      workspace: WorkspaceMapper.toDomain(entity.workspace),
      workspaceRole: entity.workspaceRole,
      status: entity.status,
      createdBy: entity.createdBy,
    };
  }

  static toPersistence(domain: WorkspaceUser): WorkspaceUserEntity {
    const entity = new WorkspaceUserEntity();

    entity.id = domain.id;
    entity.createdAt = domain.createdAt;
    entity.updatedAt = domain.updatedAt;
    entity.deletedAt = domain.deletedAt;
    entity.user = UserMapper.toPersistence(domain.user);
    entity.workspace = WorkspaceMapper.toPersistence(domain.workspace);
    entity.workspaceRole = domain.workspaceRole;
    entity.status = domain.status;

    if (domain.createdBy) {
      entity.createdBy = WorkspaceUserMapper.toPersistence(domain.createdBy);
    } else {
      entity.createdBy = null;
    }

    return entity;
  }
}
