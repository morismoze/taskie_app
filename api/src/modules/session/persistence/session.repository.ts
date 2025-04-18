import { Injectable } from '@nestjs/common';
import { Session } from './session.entity';

@Injectable()
export class SessionRepository {
  constructor(
    @InjectRepository(Session)
    private readonly repo: Repository<User>,
  ) {}

  findById(id: Session['id']): Promise<NullableType<Session>>;

  create(
    data: Omit<Session, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>,
  ): Promise<Session>;

  update(
    id: Session['id'],
    payload: Partial<
      Omit<Session, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>
    >,
  ): Promise<Session | null>;

  deleteById(id: Session['id']): Promise<void>;

  deleteByUserId(conditions: { userId: User['id'] }): Promise<void>;

  deleteByUserIdWithExclude(conditions: {
    userId: User['id'];
    excludeSessionId: Session['id'];
  }): Promise<void>;
}
