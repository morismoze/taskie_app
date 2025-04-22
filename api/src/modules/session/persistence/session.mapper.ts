import { UserMapper } from 'src/modules/user/persistence/user.mapper';
import { Session } from '../domain/session.domain';
import { SessionEntity } from './session.entity';

export class SessionMapper {
  static toDomain(entity: SessionEntity): Session {
    const domain = new Session();

    domain.user = UserMapper.toDomain(entity.user);
    domain.hash = entity.hash;
    domain.ipAddress = entity.ipAddress;
    domain.deviceId = entity.deviceId;
    domain.deviceModel = entity.deviceModel;
    domain.osVersion = entity.osVersion;
    domain.appVersion = entity.appVersion;
    domain.createdAt = entity.createdAt;
    domain.updatedAt = entity.updatedAt;
    domain.deletedAt = entity.deletedAt;

    return domain;
  }

  static toPersistence(domain: Session): SessionEntity {
    const entity = new SessionEntity();

    entity.id = domain.id;
    entity.user = UserMapper.toPersistence(domain.user);
    entity.hash = domain.hash;
    entity.ipAddress = domain.ipAddress;
    entity.deviceId = domain.deviceId;
    entity.deviceModel = domain.deviceModel;
    entity.osVersion = domain.osVersion;
    entity.appVersion = domain.appVersion;
    entity.createdAt = domain.createdAt;
    entity.updatedAt = domain.updatedAt;
    entity.deletedAt = domain.deletedAt;

    return entity;
  }
}
