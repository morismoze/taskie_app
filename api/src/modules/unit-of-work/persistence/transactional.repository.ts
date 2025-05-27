import { Injectable, Scope } from '@nestjs/common';
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
  ): Repository<Entity> {
    const entityManager = this.unitOfWorkService.getEntityManager();

    if (entityManager) {
      return entityManager.getRepository(target) as Repository<Entity>;
    }

    // this return should be triggered only in cases if TransactionalRepository
    // is used outside of the withTransaction unit of work service - basically never
    return this.unitOfWorkService
      .getDataSource()
      .getRepository(target) as Repository<Entity>;
  }
}
