import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Nullable } from 'src/common/types/nullable.type';
import { FindOptionsRelations, LessThan, Repository } from 'typeorm';
import { Session } from '../domain/session.domain';
import { SessionEntity } from './session.entity';
import { SessionRepository } from './session.repository';

@Injectable()
export class SessionRepositoryImpl implements SessionRepository {
  constructor(
    @InjectRepository(SessionEntity)
    private readonly repo: Repository<SessionEntity>,
  ) {}

  async findById({
    id,
    relations,
  }: {
    id: Session['id'];
    relations?: FindOptionsRelations<SessionEntity>;
  }): Promise<Nullable<SessionEntity>> {
    return await this.repo.findOne({
      where: { id },
      relations,
    });
  }

  async update({
    id,
    data,
    relations,
  }: {
    id: Session['id'];
    data: Partial<
      Omit<Session, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt' | 'user'>
    >;
    relations?: FindOptionsRelations<SessionEntity>;
  }): Promise<Nullable<SessionEntity>> {
    await this.repo.update(id, data);

    const newEntity = await this.findById({
      id,
      relations,
    });

    return newEntity;
  }

  async incrementAccessTokenVersionByUserId(
    id: Session['user']['id'],
  ): Promise<void> {
    await this.repo
      .createQueryBuilder()
      .update(SessionEntity)
      .set({ accessTokenVersion: () => 'access_token_version + 1' })
      .where('user_id = :id', { id })
      .execute();
  }

  async deleteById(id: Session['id']): Promise<void> {
    await this.repo.delete(id);
  }

  async deleteInactiveSessionsBefore(
    cutoffDate: Session['updatedAt'],
  ): Promise<void> {
    await this.repo.delete({
      updatedAt: LessThan(cutoffDate),
    });
  }
}
