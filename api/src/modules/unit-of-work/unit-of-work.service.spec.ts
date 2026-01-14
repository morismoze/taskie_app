import { Test, TestingModule } from '@nestjs/testing';
import { DataSource, EntityManager, QueryRunner } from 'typeorm';
import { UnitOfWorkService } from './unit-of-work.service';

describe('UnitOfWorkService', () => {
  let service: UnitOfWorkService;
  let dataSource: jest.Mocked<DataSource>;
  let queryRunner: jest.Mocked<QueryRunner>;
  let entityManager: jest.Mocked<EntityManager>;

  beforeEach(async () => {
    entityManager = {
      getRepository: jest.fn(),
    } as unknown as jest.Mocked<EntityManager>;

    queryRunner = {
      startTransaction: jest.fn(),
      commitTransaction: jest.fn(),
      rollbackTransaction: jest.fn(),
      release: jest.fn(),
      manager: entityManager,
    } as unknown as jest.Mocked<QueryRunner>;

    dataSource = {
      createQueryRunner: jest.fn().mockReturnValue(queryRunner),
    } as unknown as jest.Mocked<DataSource>;

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UnitOfWorkService,
        {
          provide: DataSource,
          useValue: dataSource,
        },
      ],
    }).compile();

    service = await module.resolve<UnitOfWorkService>(UnitOfWorkService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getEntityManager', () => {
    it('returns null entity manager initially', () => {
      const result = service.getEntityManager();

      expect(result).toBeNull();
    });

    it('returns entity manager during transaction', async () => {
      await service.withTransaction(async () => {
        const entityManagerDuringTransaction = service.getEntityManager();
        expect(entityManagerDuringTransaction).toBe(entityManager);
        return 'result';
      });
    });

    it('returns null entity manager after transaction completes', async () => {
      await service.withTransaction(async () => {
        return 'result';
      });

      const result = service.getEntityManager();
      expect(result).toBeNull();
    });
  });

  describe('getDataSource', () => {
    it('returns the data source instance', () => {
      const result = service.getDataSource();

      expect(result).toBe(dataSource);
    });
  });

  describe('withTransaction', () => {
    it('executes work and returns result on success', async () => {
      const expectedResult = { id: '123', name: 'test' };
      const workFn = jest.fn().mockResolvedValue(expectedResult);

      const result = await service.withTransaction(workFn);

      expect(result).toEqual(expectedResult);
      expect(queryRunner.startTransaction).toHaveBeenCalled();
      expect(queryRunner.commitTransaction).toHaveBeenCalled();
      expect(queryRunner.release).toHaveBeenCalled();
    });

    it('commits transaction on successful work execution', async () => {
      const workFn = jest.fn().mockResolvedValue('success');

      await service.withTransaction(workFn);

      // Verify that startTransaction is called before commitTransaction
      // hack for toHaveBeenCalledBefore
      const startTransaction =
        queryRunner.startTransaction.mock.invocationCallOrder[0];
      const commitTransaction =
        queryRunner.commitTransaction.mock.invocationCallOrder[0];
      expect(startTransaction).toBeLessThan(commitTransaction);
      expect(queryRunner.commitTransaction).toHaveBeenCalled();
    });

    it('rollbacks transaction on work execution error', async () => {
      const error = new Error('Work failed');
      const workFn = jest.fn().mockRejectedValue(error);

      await expect(service.withTransaction(workFn)).rejects.toThrow(
        'Work failed',
      );

      expect(queryRunner.rollbackTransaction).toHaveBeenCalled();
      expect(queryRunner.commitTransaction).not.toHaveBeenCalled();
    });

    it('releases query runner after transaction completes', async () => {
      const workFn = jest.fn().mockResolvedValue('result');

      await service.withTransaction(workFn);

      expect(queryRunner.release).toHaveBeenCalled();
    });

    it('releases query runner after transaction fails', async () => {
      const workFn = jest.fn().mockRejectedValue(new Error('Failed'));

      try {
        await service.withTransaction(workFn);
      } catch {
        // Expected to fail
      }

      expect(queryRunner.release).toHaveBeenCalled();
    });

    it('clears entity manager after transaction completes', async () => {
      const workFn = jest.fn().mockResolvedValue('result');

      await service.withTransaction(workFn);

      expect(service.getEntityManager()).toBeNull();
    });

    it('clears entity manager after transaction fails', async () => {
      const workFn = jest.fn().mockRejectedValue(new Error('Failed'));

      try {
        await service.withTransaction(workFn);
      } catch {
        // Expected to fail
      }

      expect(service.getEntityManager()).toBeNull();
    });

    it('creates new query runner from data source', async () => {
      const workFn = jest.fn().mockResolvedValue('result');

      await service.withTransaction(workFn);

      expect(dataSource.createQueryRunner).toHaveBeenCalled();
    });

    it('executes work function inside transaction', async () => {
      const workFn = jest.fn().mockResolvedValue('result');

      await service.withTransaction(workFn);

      expect(workFn).toHaveBeenCalled();
    });

    it('provides access to entity manager during work', async () => {
      const workFn = jest.fn(async () => {
        const em = service.getEntityManager();
        expect(em).toBe(entityManager);
        return 'result';
      });

      await service.withTransaction(workFn);

      expect(workFn).toHaveBeenCalled();
    });

    it('preserves error thrown during work', async () => {
      const testError = new Error('Custom error message');
      const workFn = jest.fn().mockRejectedValue(testError);

      try {
        await service.withTransaction(workFn);
        fail('Should have thrown error');
      } catch (error) {
        expect(error).toBe(testError);
        expect((error as Error).message).toBe('Custom error message');
      }
    });

    it('handles sync work function', async () => {
      const result = { value: 42 };
      const workFn = jest.fn().mockReturnValue(result);

      const output = await service.withTransaction(workFn);

      expect(output).toEqual(result);
      expect(queryRunner.commitTransaction).toHaveBeenCalled();
    });

    it('handles async work function', async () => {
      const result = { value: 42 };
      const workFn = jest.fn(async () => {
        await new Promise((resolve) => setTimeout(resolve, 10));
        return result;
      });

      const output = await service.withTransaction(workFn);

      expect(output).toEqual(result);
      expect(queryRunner.commitTransaction).toHaveBeenCalled();
    });

    it('executes work function exactly once', async () => {
      const workFn = jest.fn().mockResolvedValue('result');

      await service.withTransaction(workFn);

      expect(workFn).toHaveBeenCalledTimes(1);
    });

    it('cleans up resources in finally block even if release throws', async () => {
      (queryRunner.release as jest.Mock).mockRejectedValue(
        new Error('Release failed'),
      );
      const workFn = jest.fn().mockResolvedValue('result');

      try {
        await service.withTransaction(workFn);
      } catch {
        // Expected - release failed
      }

      // Entity manager should still be cleared
      expect(service.getEntityManager()).toBeNull();
    });

    it('handles multiple sequential transactions', async () => {
      const workFn1 = jest.fn().mockResolvedValue('result1');
      const workFn2 = jest.fn().mockResolvedValue('result2');

      const result1 = await service.withTransaction(workFn1);
      const result2 = await service.withTransaction(workFn2);

      expect(result1).toBe('result1');
      expect(result2).toBe('result2');
      expect(dataSource.createQueryRunner).toHaveBeenCalledTimes(2);
      expect(queryRunner.release).toHaveBeenCalledTimes(2);
    });

    it('transaction order: start -> work -> commit -> release', async () => {
      const callOrder: string[] = [];
      (queryRunner.startTransaction as jest.Mock).mockImplementation(() => {
        callOrder.push('start');
      });
      (queryRunner.commitTransaction as jest.Mock).mockImplementation(() => {
        callOrder.push('commit');
      });
      (queryRunner.release as jest.Mock).mockImplementation(() => {
        callOrder.push('release');
      });

      const workFn = jest.fn(async () => {
        callOrder.push('work');
        return 'result';
      });

      await service.withTransaction(workFn);

      expect(callOrder).toEqual(['start', 'work', 'commit', 'release']);
    });

    it('rollback happens before release on error', async () => {
      const callOrder: string[] = [];
      (queryRunner.rollbackTransaction as jest.Mock).mockImplementation(() => {
        callOrder.push('rollback');
      });
      (queryRunner.release as jest.Mock).mockImplementation(() => {
        callOrder.push('release');
      });

      const workFn = jest.fn().mockRejectedValue(new Error('Failed'));

      try {
        await service.withTransaction(workFn);
      } catch {
        // Expected
      }

      expect(callOrder).toEqual(['rollback', 'release']);
    });
  });
});
