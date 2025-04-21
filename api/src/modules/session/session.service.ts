import {
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { Session } from './domain/session.domain';
import { SessionRepository } from './persistence/session.repository';

@Injectable()
export class SessionService {
  constructor(private readonly sessionRepository: SessionRepository) {}

  async create(
    userId: Session['user']['id'],
    hash: Session['hash'],
  ): Promise<Session> {
    const newSession = await this.sessionRepository.create(userId, hash);

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

    const updatedSession = await this.sessionRepository.update({
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
