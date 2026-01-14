import { Test, TestingModule } from '@nestjs/testing';
import { DataSource } from 'typeorm';
import { UnitOfWorkService } from './unit-of-work.service';

const createMockEntityManager = () => ({
  getRepository: jest.fn(),
  save: jest.fn(),
  findOne: jest.fn(),
});

const createMockQueryRunner = (entityManager: any) => ({
  startTransaction: jest.fn(),
  commitTransaction: jest.fn(),
  rollbackTransaction: jest.fn(),
  release: jest.fn(),
  manager: entityManager,
});

const createMockDataSource = (queryRunner: any) => ({
  createQueryRunner: jest.fn().mockReturnValue(queryRunner),
});

describe('UnitOfWorkService', () => {
  let service: UnitOfWorkService;
  let dataSource: ReturnType<typeof createMockDataSource>;
  let queryRunner: ReturnType<typeof createMockQueryRunner>;
  let entityManager: ReturnType<typeof createMockEntityManager>;

  beforeEach(async () => {
    jest.clearAllMocks();

    entityManager = createMockEntityManager();
    queryRunner = createMockQueryRunner(entityManager);
    dataSource = createMockDataSource(queryRunner);

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

  describe('getEntityManager', () => {
    it('returns null entity manager initially', () => {
      expect(service.getEntityManager()).toBeNull();
    });

    it('returns entity manager during transaction', async () => {
      await service.withTransaction(async () => {
        const em = service.getEntityManager();
        expect(em).toBe(entityManager);
        return 'result';
      });
    });

    it('returns null entity manager after transaction completes', async () => {
      await service.withTransaction(async () => {
        return 'result';
      });

      expect(service.getEntityManager()).toBeNull();
    });
  });

  describe('getDataSource', () => {
    it('returns the data source instance', () => {
      expect(service.getDataSource()).toBe(dataSource);
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

      expect(queryRunner.startTransaction).toHaveBeenCalled();
      expect(queryRunner.commitTransaction).toHaveBeenCalled();

      const startOrder =
        queryRunner.startTransaction.mock.invocationCallOrder[0];
      const commitOrder =
        queryRunner.commitTransaction.mock.invocationCallOrder[0];
      expect(startOrder).toBeLessThan(commitOrder);
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

      await expect(service.withTransaction(workFn)).rejects.toThrow();

      expect(queryRunner.release).toHaveBeenCalled();
    });

    it('clears entity manager after transaction completes', async () => {
      await service.withTransaction(async () => 'result');

      expect(service.getEntityManager()).toBeNull();
    });

    it('clears entity manager after transaction fails', async () => {
      const workFn = jest.fn().mockRejectedValue(new Error('Failed'));

      try {
        await service.withTransaction(workFn);
      } catch {
        // Ignored
      }

      expect(service.getEntityManager()).toBeNull();
    });

    it('creates new query runner from data source', async () => {
      await service.withTransaction(async () => 'result');

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

      await expect(service.withTransaction(workFn)).rejects.toBe(testError);
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

    it('cleans up resources in finally block even if release throws', async () => {
      queryRunner.release.mockRejectedValue(new Error('Release failed'));

      const workFn = jest.fn().mockResolvedValue('result');

      await expect(service.withTransaction(workFn)).rejects.toThrow(
        'Release failed',
      );

      expect(service.getEntityManager()).toBeNull();
    });

    it('handles multiple sequential transactions correctly', async () => {
      const workFn1 = jest.fn().mockResolvedValue('result1');
      const workFn2 = jest.fn().mockResolvedValue('result2');

      const result1 = await service.withTransaction(workFn1);
      const result2 = await service.withTransaction(workFn2);

      expect(result1).toBe('result1');
      expect(result2).toBe('result2');
      expect(dataSource.createQueryRunner).toHaveBeenCalledTimes(2);
      expect(queryRunner.release).toHaveBeenCalledTimes(2);
    });

    it('follows transaction order: start -> work -> commit -> release', async () => {
      const callOrder: string[] = [];

      queryRunner.startTransaction.mockImplementation(async () =>
        callOrder.push('start'),
      );
      queryRunner.commitTransaction.mockImplementation(async () =>
        callOrder.push('commit'),
      );
      queryRunner.release.mockImplementation(async () =>
        callOrder.push('release'),
      );

      const workFn = jest.fn(async () => {
        callOrder.push('work');
        return 'result';
      });

      await service.withTransaction(workFn);

      expect(callOrder).toEqual(['start', 'work', 'commit', 'release']);
    });

    it('follows rollback order: start -> work -> rollback -> release', async () => {
      const callOrder: string[] = [];

      queryRunner.startTransaction.mockImplementation(async () =>
        callOrder.push('start'),
      );
      queryRunner.rollbackTransaction.mockImplementation(async () =>
        callOrder.push('rollback'),
      );
      queryRunner.release.mockImplementation(async () =>
        callOrder.push('release'),
      );

      const workFn = jest.fn(async () => {
        callOrder.push('work');
        throw new Error('Fail');
      });

      await expect(service.withTransaction(workFn)).rejects.toThrow();

      expect(callOrder).toEqual(['start', 'work', 'rollback', 'release']);
    });
  });
});
