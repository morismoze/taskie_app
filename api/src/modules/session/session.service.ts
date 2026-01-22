import { HttpStatus, Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { SessionCore } from './domain/session-core.domain';
import { Session } from './domain/session.domain';
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
    private readonly sessionRepository: TransactionalSessionRepository,
  ) {}

  async create(data: {
    userId: Session['user']['id'];
    hash: Session['hash'];
    ipAddress: Session['ipAddress'];
    deviceModel: Session['deviceModel'];
    osVersion: Session['osVersion'];
    appVersion: Session['appVersion'];
    buildNumber: Session['buildNumber'];
  }): Promise<SessionCore> {
    const newSession = await this.sessionRepository.create({
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

  findById(id: Session['id']): Promise<Nullable<SessionCore>> {
    return this.sessionRepository.findById({
      id,
    });
  }

  findByIdWithUser(id: Session['id']): Promise<Nullable<Session>> {
    return this.sessionRepository.findById({
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
      Omit<
        Session,
        | 'id'
        | 'accessTokenVersion'
        | 'createdAt'
        | 'updatedAt'
        | 'deletedAt'
        | 'user'
      >
    >;
  }): Promise<SessionCore> {
    const updatedSession = await this.sessionRepository.update({
      id,
      data,
    });

    if (!updatedSession) {
      // This should not happen in a normal user flow.
      // We delete user session only on logout.
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    return updatedSession;
  }

  incrementAccessTokenVersionByUserId(
    id: Session['user']['id'],
  ): Promise<void> {
    return this.sessionRepository.incrementAccessTokenVersionByUserId(id);
  }

  async delete(id: Session['id']): Promise<void> {
    await this.sessionRepository.delete(id);
  }
}
