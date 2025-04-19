import { Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { Session } from './domain/session.domain';
import { SessionRepository } from './persistence/session.repository';

@Injectable()
export class SessionService {
  constructor(private readonly sessionRepository: SessionRepository) {}

  create(
    userId: Session['user']['id'],
    hash: Session['hash'],
  ): Promise<Session> {
    return this.sessionRepository.create(userId, hash);
  }

  findById(id: Session['id']): Promise<Nullable<Session>> {
    return this.sessionRepository.findById(id);
  }

  async update(
    id: Session['id'],
    hash: Session['hash'],
  ): Promise<Session | null> {
    const session = await this.findById(id);

    if (!session) {
      return null;
    }

    const updatedSession: Session = {
      ...session,
      hash,
    };

    return this.sessionRepository.update(updatedSession);
  }

  deleteById(id: Session['id']): Promise<void> {
    return this.sessionRepository.deleteById(id);
  }
}
