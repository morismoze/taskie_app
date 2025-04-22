import {
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { Session } from './domain/session.domain';
import { SessionRepository } from './persistence/session.repository';

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
  constructor(private readonly sessionRepository: SessionRepository) {}

  async create(
    data: Omit<Session, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>,
  ): Promise<Session> {
    const newSession = await this.sessionRepository.create(data);

    if (!newSession) {
      throw new InternalServerErrorException();
    }

    return newSession;
  }

  findById(id: Session['id']): Promise<Nullable<Session>> {
    return this.sessionRepository.findById(id);
  }

  async update(id: Session['id'], hash: Session['hash']): Promise<Session> {
    const session = await this.findById(id);

    if (!session) {
      throw new NotFoundException();
    }

    const updatedSession = await this.sessionRepository.update(id, {
      ...session,
      hash,
    });

    if (!updatedSession) {
      throw new InternalServerErrorException();
    }

    return updatedSession;
  }

  deleteById(id: Session['id']): Promise<void> {
    return this.sessionRepository.deleteById(id);
  }
}
