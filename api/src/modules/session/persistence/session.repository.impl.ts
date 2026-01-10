import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { LessThan, Repository } from 'typeorm';
import { Session } from '../domain/session.domain';
import { SessionEntity } from './session.entity';
import { SessionRepository } from './session.repository';

@Injectable()
export class SessionRepositoryImpl implements SessionRepository {
  constructor(
    @InjectRepository(SessionEntity)
    private readonly repo: Repository<SessionEntity>,
  ) {}

  async deleteInactiveSessionsBefore(
    cutoffDate: Session['updatedAt'],
  ): Promise<void> {
    await this.repo.delete({
      updatedAt: LessThan(cutoffDate),
    });
  }
}
