import { Injectable, Scope } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { EntitySchema, ObjectLiteral, ObjectType, Repository } from 'typeorm';
import { UnitOfWorkService } from '../unit-of-work.service';

/**
 * This repository is request scoped because transaction has to be request scoped
 */

@Injectable({ scope: Scope.REQUEST })
export class TransactionalRepository {
  constructor(private unitOfWorkService: UnitOfWorkService) {}
  /**
   * Gets a repository bound to the current transaction manager
   * or defaults to the current connection's call to getRepository().
   */
  getRepository<Entity extends ObjectLiteral>(
    target: ObjectType<Entity> | EntitySchema<Entity> | string,
  ): Nullable<Repository<Entity>> {
    const entityManager = this.unitOfWorkService.getEntityManager();

    if (entityManager) {
      return entityManager.getRepository(target) as Repository<Entity>;
    }

    // TransactionalRepository is used outside of the withTransaction unit of work service
    return null;
  }
}
