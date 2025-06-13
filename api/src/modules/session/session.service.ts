import { HttpStatus, Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/ApiHttpException.type';
import { SessionCore } from './domain/session-core.domain';
import { Session } from './domain/session.domain';
import { SessionRepository } from './persistence/session.repository';
import { TransactionalSessionRepository } from './persistence/transactional/transactional-session.repository';

/**
 * We create sessions on user login because:
 * 1. we can then track multiple active session (e.g. across devices) and that enables e.g.:
 *  a. Log out from all devices
 *  b. Show recent sessions
 *  c. Kill specific session
 * 2. we can have secure refresh token validation (hash compare), so we have stateless refresh tokens, but
 * with a stateful validation step. This way we have refresh token rotation.
 */
@Injectable()
export class SessionService {
  constructor(
    private readonly sessionRepository: SessionRepository,
    private readonly transactionalSessionRepository: TransactionalSessionRepository,
  ) {}

  async create(data: {
    userId: Session['user']['id'];
    hash: Session['hash'];
    ipAddress: Session['ipAddress'];
    deviceModel: Session['deviceModel'];
    osVersion: Session['osVersion'];
    appVersion: Session['appVersion'];
  }): Promise<SessionCore> {
    const newSession = await this.transactionalSessionRepository.create({
      data,
    });

    if (!newSession) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return newSession;
  }

  async findById(id: Session['id']): Promise<Nullable<SessionCore>> {
    return await this.sessionRepository.findById({
      id,
    });
  }

  async findByIdWithUser(id: Session['id']): Promise<Nullable<Session>> {
    return await this.sessionRepository.findById({
      id,
      relations: { user: true },
    });
  }

  async update({
    id,
    data,
  }: {
    id: Session['id'];
    data: Partial<
      Omit<Session, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt' | 'user'>
    >;
  }): Promise<SessionCore> {
    const updatedSession = await this.sessionRepository.update({
      id,
      data,
    });

    if (!updatedSession) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return updatedSession;
  }

  deleteById(id: Session['id']): Promise<void> {
    return this.sessionRepository.deleteById(id);
  }
}
