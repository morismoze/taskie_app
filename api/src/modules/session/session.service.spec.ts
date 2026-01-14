import { HttpStatus } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { SessionEntity } from './persistence/session.entity';
import { TransactionalSessionRepository } from './persistence/transactional/transactional-session.repository';
import { SessionService } from './session.service';

describe('SessionService', () => {
  let service: SessionService;
  let sessionRepository: jest.Mocked<TransactionalSessionRepository>;

  const mockSessionEntity: SessionEntity = {
    id: 'session-1',
    hash: 'session-hash-123',
    ipAddress: '192.168.1.1',
    deviceModel: 'iPhone 15',
    osVersion: 'iOS 17.0',
    appVersion: '1.0.0',
    accessTokenVersion: 1,
    createdAt: new Date('2024-01-01'),
    updatedAt: new Date('2024-01-01'),
    deletedAt: null,
  } as SessionEntity;

  const mockSessionEntityWithUser: SessionEntity = {
    ...mockSessionEntity,
    user: {
      id: 'user-1',
      email: 'test@example.com',
      firstName: 'John',
      lastName: 'Doe',
      profileImageUrl: null,
      provider: null,
      socialId: null,
      status: 'ACTIVE',
      createdAt: new Date('2024-01-01'),
      updatedAt: new Date('2024-01-01'),
      deletedAt: null,
    },
  } as SessionEntity;

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SessionService,
        {
          provide: TransactionalSessionRepository,
          useValue: {
            create: jest.fn(),
            findById: jest.fn(),
            update: jest.fn(),
            incrementAccessTokenVersionByUserId: jest.fn(),
            deleteById: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<SessionService>(SessionService);
    sessionRepository = module.get(
      TransactionalSessionRepository,
    ) as jest.Mocked<TransactionalSessionRepository>;
  });

  describe('create', () => {
    it('creates a session', async () => {
      sessionRepository.create.mockResolvedValue(mockSessionEntity);

      const payload = {
        userId: 'user-id',
        hash: 'session-hash',
        ipAddress: '192.168.1.1',
        deviceModel: 'iPhone 12',
        osVersion: 'iOS 14.5',
        appVersion: '1.0.0',
      };
      const result = await service.create(payload);

      expect(sessionRepository.create).toHaveBeenCalledWith({ data: payload });
      expect(result).toEqual(mockSessionEntity);
    });

    it('throws ApiHttpException SERVER_ERROR exception if there was a problem creating the session via the repository', async () => {
      sessionRepository.create.mockResolvedValue(null);

      const payload = {
        userId: 'user-id',
        hash: 'session-hash',
        ipAddress: '192.168.1.1',
        deviceModel: 'iPhone 12',
        osVersion: 'iOS 14.5',
        appVersion: '1.0.0',
      };

      // We don't use result constant here because we expect an exception
      try {
        await service.create(payload);
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);

        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.INTERNAL_SERVER_ERROR,
        );

        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.SERVER_ERROR,
        });
      }
      expect(sessionRepository.create).toHaveBeenCalledWith({ data: payload });
    });
  });

  describe('findById', () => {
    it('returns a session by ID', async () => {
      sessionRepository.findById.mockResolvedValue(mockSessionEntity);

      const payload = 'session-id';
      const result = await service.findById(payload);

      expect(sessionRepository.findById).toHaveBeenCalledWith({ id: payload });
      expect(result).toEqual(mockSessionEntity);
    });

    it('returns null if session is not found', async () => {
      sessionRepository.findById.mockResolvedValue(null);

      const payload = 'session-id';
      const result = await service.findById(payload);

      expect(sessionRepository.findById).toHaveBeenCalledWith({ id: payload });
      expect(result).toBeNull();
    });
  });

  describe('findByIdWithUser', () => {
    it('returns a session by ID with user relation', async () => {
      sessionRepository.findById.mockResolvedValue(mockSessionEntityWithUser);

      const payload = 'session-id';
      const result = await service.findByIdWithUser(payload);

      expect(sessionRepository.findById).toHaveBeenCalledWith({
        id: payload,
        relations: { user: true },
      });
      expect(result).toEqual(mockSessionEntityWithUser);
    });

    it('returns null if session is not found', async () => {
      sessionRepository.findById.mockResolvedValue(null);

      const payload = 'non-existent-session-id';
      const result = await service.findByIdWithUser(payload);

      expect(sessionRepository.findById).toHaveBeenCalledWith({
        id: payload,
        relations: { user: true },
      });
      expect(result).toBeNull();
    });
  });

  describe('update', () => {
    it('updates a session with new data', async () => {
      const updatedSessionEntity = {
        ...mockSessionEntity,
        hash: 'new-hash',
      } as SessionEntity;
      sessionRepository.update.mockResolvedValue(updatedSessionEntity);

      const id = 'session-id';
      const data = { hash: 'new-hash' };
      const result = await service.update({ id, data });

      expect(sessionRepository.update).toHaveBeenCalledWith({
        id,
        data,
      });
      expect(result).toEqual(updatedSessionEntity);
    });

    it('throws ApiHttpException INVALID_PAYLOAD if session not found during update', async () => {
      sessionRepository.update.mockResolvedValue(null);

      const id = 'session-id';
      const data = { hash: 'new-hash' };

      try {
        await service.update({ id, data });
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.NOT_FOUND,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.INVALID_PAYLOAD,
        });
      }
      expect(sessionRepository.update).toHaveBeenCalledWith({
        id,
        data,
      });
    });
  });

  describe('incrementAccessTokenVersionByUserId', () => {
    it('increments access token version for a user', async () => {
      sessionRepository.incrementAccessTokenVersionByUserId.mockResolvedValue(
        undefined,
      );

      const userId = 'user-id';
      await service.incrementAccessTokenVersionByUserId(userId);

      expect(
        sessionRepository.incrementAccessTokenVersionByUserId,
      ).toHaveBeenCalledWith(userId);
    });
  });

  describe('deleteById', () => {
    it('deletes a session by ID', async () => {
      sessionRepository.deleteById.mockResolvedValue(true);

      const id = 'session-id';
      await service.deleteById(id);

      expect(sessionRepository.deleteById).toHaveBeenCalledWith(id);
    });
  });
});
