import { HttpStatus } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { SessionEntity } from './persistence/session.entity';
import { TransactionalSessionRepository } from './persistence/transactional/transactional-session.repository';
import { SessionService } from './session.service';

const mockUserEntityFactory = (overrides?: Partial<UserEntity>): UserEntity =>
  ({
    id: 'user-1',
    email: 'test@example.com',
    firstName: 'John',
    lastName: 'Doe',
    profileImageUrl: null,
    provider: null,
    socialId: null,
    status: 'ACTIVE',
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
    ...overrides,
  }) as UserEntity;

const mockSessionEntityFactory = (
  overrides?: Partial<SessionEntity>,
): SessionEntity => {
  const base = {
    id: 'session-1',
    hash: 'session-hash-123',
    ipAddress: '192.168.1.1',
    deviceModel: 'iPhone 15',
    osVersion: 'iOS 17.0',
    appVersion: '1.0.0',
    accessTokenVersion: 1,
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
    // By default, no user relation loaded unless specified
    user: undefined,
    ...overrides,
  };

  return base as unknown as SessionEntity;
};

const createMockRepository = () => ({
  create: jest.fn(),
  findById: jest.fn(),
  update: jest.fn(),
  incrementAccessTokenVersionByUserId: jest.fn(),
  deleteById: jest.fn(),
});

describe('SessionService', () => {
  let service: SessionService;
  let sessionRepository: ReturnType<typeof createMockRepository>;

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SessionService,
        {
          provide: TransactionalSessionRepository,
          useValue: createMockRepository(),
        },
      ],
    }).compile();

    service = module.get<SessionService>(SessionService);
    sessionRepository = module.get(TransactionalSessionRepository);
  });

  describe('create', () => {
    it('creates a session', async () => {
      const mockSession = mockSessionEntityFactory();
      sessionRepository.create.mockResolvedValue(mockSession);

      const payload = {
        userId: 'user-id',
        hash: 'session-hash',
        ipAddress: '192.168.1.1',
        deviceModel: 'iPhone 12',
        osVersion: 'iOS 14.5',
        appVersion: '1.0.0',
        buildNumber: '1',
      };
      const result = await service.create(payload);

      expect(sessionRepository.create).toHaveBeenCalledWith({ data: payload });
      expect(result).toEqual(mockSession);
    });

    it('throws SERVER_ERROR exception if creation returns null', async () => {
      sessionRepository.create.mockResolvedValue(null);

      const payload = {
        userId: 'user-id',
        hash: 'session-hash',
        ipAddress: '192.168.1.1',
        deviceModel: 'iPhone 12',
        osVersion: 'iOS 14.5',
        appVersion: '1.0.0',
        buildNumber: '1',
      };

      await expect(service.create(payload)).rejects.toMatchObject({
        status: HttpStatus.INTERNAL_SERVER_ERROR,
        response: { code: ApiErrorCode.SERVER_ERROR },
      });

      expect(sessionRepository.create).toHaveBeenCalledWith({ data: payload });
    });
  });

  describe('findById', () => {
    it('returns a session by ID', async () => {
      const mockSession = mockSessionEntityFactory();
      sessionRepository.findById.mockResolvedValue(mockSession);

      const payload = 'session-id';
      const result = await service.findById(payload);

      expect(sessionRepository.findById).toHaveBeenCalledWith({ id: payload });
      expect(result).toEqual(mockSession);
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
      const mockSessionWithUser = mockSessionEntityFactory({
        user: mockUserEntityFactory(),
      });
      sessionRepository.findById.mockResolvedValue(mockSessionWithUser);

      const payload = 'session-id';
      const result = await service.findByIdWithUser(payload);

      expect(sessionRepository.findById).toHaveBeenCalledWith({
        id: payload,
        relations: { user: true },
      });
      expect(result).toEqual(mockSessionWithUser);
      expect(result?.user).toBeDefined();
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
      const updatedSession = mockSessionEntityFactory({
        hash: 'new-hash',
      });
      sessionRepository.update.mockResolvedValue(updatedSession);

      const id = 'session-id';
      const data = { hash: 'new-hash' };
      const result = await service.update({ id, data });

      expect(sessionRepository.update).toHaveBeenCalledWith({
        id,
        data,
      });
      expect(result).toEqual(updatedSession);
    });

    it('throws INVALID_PAYLOAD if session not found during update', async () => {
      sessionRepository.update.mockResolvedValue(null);

      const id = 'session-id';
      const data = { hash: 'new-hash' };

      await expect(service.update({ id, data })).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });

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
