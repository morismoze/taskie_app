import { Injectable, Scope } from '@nestjs/common';
import { DataSource, EntityManager } from 'typeorm';

/**
 * A unit of work instance is created per every request because transaction should
 * be closed before the request is resolved.
 * We also want to free up the DB connection back to the connection pool.
 */

@Injectable({ scope: Scope.REQUEST })
export class UnitOfWorkService {
  private entityManager: EntityManager | null;

  constructor(private readonly dataSource: DataSource) {
    this.entityManager = null;
  }

  getEntityManager(): EntityManager | null {
    return this.entityManager;
  }

  getDataSource(): DataSource {
    return this.dataSource;
  }

  async withTransaction<T>(work: () => T): Promise<T> {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.startTransaction();
    this.entityManager = queryRunner.manager;

    try {
      const result = await work();
      await queryRunner.commitTransaction();
      return result;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      throw error;
    } finally {
      await queryRunner.release();
      this.entityManager = null;
    }
  }
}
