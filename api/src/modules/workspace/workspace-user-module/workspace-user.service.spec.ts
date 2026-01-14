import { HttpStatus } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceLeaderboardResponse } from '../workspace-module/dto/response/workspace-leaderboard-response.dto';
import { WorkspaceUserRole } from './domain/workspace-user-role.enum';
import { WorkspaceUserEntity } from './persistence/workspace-user.entity';
import { WorkspaceUserRepository } from './persistence/workspace-user.repository';
import { WorkspaceUserService } from './workspace-user.service';

const mockUserFactory = (overrides?: Partial<User>): User =>
  ({
    id: 'user-1',
    firstName: 'John',
    lastName: 'Doe',
    profileImageUrl: 'https://example.com/image.jpg',
    email: 'john@example.com',
    status: 'ACTIVE',
    ...overrides,
  }) as User;

const mockWorkspaceUserEntityFactory = (
  overrides?: Partial<WorkspaceUserEntity>,
): WorkspaceUserEntity => {
  const base = {
    id: 'workspace-user-1',
    workspaceRole: WorkspaceUserRole.MEMBER,
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
    userId: 'user-1',
    user: mockUserFactory(),
    workspace: {
      id: 'workspace-1',
      name: 'Test Workspace',
    },
    createdBy: null,
    ...overrides,
  };

  return base as unknown as WorkspaceUserEntity;
};

const createMockRepository = () => ({
  create: jest.fn(),
  findByIdAndWorkspaceId: jest.fn(),
  findByUserIdAndWorkspaceId: jest.fn(),
  findByIdsAndWorkspaceId: jest.fn(),
  findAllByUserId: jest.fn(),
  findAllByIds: jest.fn(),
  findAllByWorkspaceId: jest.fn(),
  countManagersInWorkspace: jest.fn(),
  update: jest.fn(),
  delete: jest.fn(),
  getWorkspaceLeaderboard: jest.fn(),
});

describe('WorkspaceUserService', () => {
  let service: WorkspaceUserService;
  let workspaceUserRepository: ReturnType<typeof createMockRepository>;

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        WorkspaceUserService,
        {
          provide: WorkspaceUserRepository,
          useValue: createMockRepository(),
        },
      ],
    }).compile();

    service = module.get<WorkspaceUserService>(WorkspaceUserService);
    workspaceUserRepository = module.get(WorkspaceUserRepository);
  });

  describe('create', () => {
    it('creates a new workspace user and maps createdBy relation correctly', async () => {
      const creatorUser = mockUserFactory({
        id: 'creator-user-id',
        firstName: 'Creator',
      });
      const mockEntity = mockWorkspaceUserEntityFactory({
        createdBy: {
          id: 'creator-ws-user-id',
          user: creatorUser,
        } as unknown as WorkspaceUserEntity,
      });

      workspaceUserRepository.create.mockResolvedValue(mockEntity);

      const result = await service.create({
        workspaceId: 'workspace-1',
        createdById: 'creator-ws-user-id',
        userId: 'user-2',
        workspaceRole: WorkspaceUserRole.MEMBER,
      });

      expect(workspaceUserRepository.create).toHaveBeenCalledWith({
        data: {
          workspaceId: 'workspace-1',
          createdById: 'creator-ws-user-id',
          userId: 'user-2',
          workspaceRole: WorkspaceUserRole.MEMBER,
        },
        relations: {
          createdBy: {
            user: true,
          },
        },
      });

      expect(result.createdBy).toEqual({
        id: 'creator-ws-user-id',
        firstName: creatorUser.firstName,
        lastName: creatorUser.lastName,
        profileImageUrl: creatorUser.profileImageUrl,
      });
    });

    it('creates workspace user with null createdById', async () => {
      const mockEntity = mockWorkspaceUserEntityFactory({
        createdBy: null,
      });
      workspaceUserRepository.create.mockResolvedValue(mockEntity);

      const result = await service.create({
        workspaceId: 'workspace-1',
        createdById: null,
        userId: 'user-2',
        workspaceRole: WorkspaceUserRole.MANAGER,
      });

      expect(result.createdBy).toBeNull();
    });

    it('throws SERVER_ERROR if repository returns null', async () => {
      workspaceUserRepository.create.mockResolvedValue(null);

      await expect(
        service.create({
          workspaceId: 'workspace-1',
          createdById: 'user-1',
          userId: 'user-2',
          workspaceRole: WorkspaceUserRole.MEMBER,
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.INTERNAL_SERVER_ERROR,
        response: { code: ApiErrorCode.SERVER_ERROR },
      });
    });
  });

  describe('findByIdAndWorkspaceId', () => {
    it('returns workspace user core data', async () => {
      const mockEntity = mockWorkspaceUserEntityFactory();
      workspaceUserRepository.findByIdAndWorkspaceId.mockResolvedValue(
        mockEntity,
      );

      const result = await service.findByIdAndWorkspaceId({
        id: 'workspace-user-1',
        workspaceId: 'workspace-1',
      });

      expect(result).toEqual(mockEntity);
    });

    it('returns null if not found', async () => {
      workspaceUserRepository.findByIdAndWorkspaceId.mockResolvedValue(null);

      const result = await service.findByIdAndWorkspaceId({
        id: 'workspace-user-1',
        workspaceId: 'workspace-1',
      });

      expect(result).toBeNull();
    });
  });

  describe('findByUserIdAndWorkspaceId', () => {
    it('returns workspace user by user id', async () => {
      const mockEntity = mockWorkspaceUserEntityFactory();
      workspaceUserRepository.findByUserIdAndWorkspaceId.mockResolvedValue(
        mockEntity,
      );

      const result = await service.findByUserIdAndWorkspaceId({
        userId: 'user-1',
        workspaceId: 'workspace-1',
      });

      expect(result).toEqual(mockEntity);
    });

    it('returns null if not found', async () => {
      workspaceUserRepository.findByUserIdAndWorkspaceId.mockResolvedValue(
        null,
      );

      const result = await service.findByUserIdAndWorkspaceId({
        userId: 'user-1',
        workspaceId: 'workspace-1',
      });

      expect(result).toBeNull();
    });
  });

  describe('findByIdAndWorkspaceIdWithUser', () => {
    it('returns workspace user with user relation', async () => {
      const mockEntity = mockWorkspaceUserEntityFactory();
      workspaceUserRepository.findByIdAndWorkspaceId.mockResolvedValue(
        mockEntity,
      );

      const result = await service.findByIdAndWorkspaceIdWithUser({
        id: 'user-1',
        workspaceId: 'workspace-1',
      });

      expect(
        workspaceUserRepository.findByIdAndWorkspaceId,
      ).toHaveBeenCalledWith({
        id: 'user-1',
        workspaceId: 'workspace-1',
        relations: { user: true },
      });
      expect(result).toEqual(mockEntity);
    });
  });

  describe('findByIdAndWorkspaceIdWithUserAndCreatedByUser', () => {
    it('returns null if workspace user not found', async () => {
      workspaceUserRepository.findByIdAndWorkspaceId.mockResolvedValue(null);

      const result =
        await service.findByIdAndWorkspaceIdWithUserAndCreatedByUser({
          id: 'user-1',
          workspaceId: 'workspace-1',
        });

      expect(result).toBeNull();
    });

    it('returns mapped data when createdBy exists', async () => {
      const creator = mockUserFactory({ firstName: 'Boss' });
      const mockEntity = mockWorkspaceUserEntityFactory({
        createdBy: {
          id: 'creator-ws-id',
          user: creator,
        } as unknown as WorkspaceUserEntity,
      });

      workspaceUserRepository.findByIdAndWorkspaceId.mockResolvedValue(
        mockEntity,
      );

      const result =
        await service.findByIdAndWorkspaceIdWithUserAndCreatedByUser({
          id: 'user-1',
          workspaceId: 'workspace-1',
        });

      expect(result?.createdBy).toEqual({
        id: 'creator-ws-id',
        firstName: creator.firstName,
        lastName: creator.lastName,
        profileImageUrl: creator.profileImageUrl,
      });
    });

    it('returns mapped data when createdBy is null', async () => {
      const mockEntity = mockWorkspaceUserEntityFactory({ createdBy: null });
      workspaceUserRepository.findByIdAndWorkspaceId.mockResolvedValue(
        mockEntity,
      );

      const result =
        await service.findByIdAndWorkspaceIdWithUserAndCreatedByUser({
          id: 'user-1',
          workspaceId: 'workspace-1',
        });

      expect(result?.createdBy).toBeNull();
    });
  });

  describe('findByIdsAndWorkspaceIdWithUserAndCreatedByUser', () => {
    it('returns null if not all requested users are found', async () => {
      const mockEntity = mockWorkspaceUserEntityFactory();
      workspaceUserRepository.findByIdsAndWorkspaceId.mockResolvedValue([
        mockEntity,
      ]);

      const result =
        await service.findByIdsAndWorkspaceIdWithUserAndCreatedByUser({
          ids: ['user-1', 'user-2'],
          workspaceId: 'workspace-1',
        });

      expect(result).toBeNull();
    });

    it('returns mapped array when all users are found', async () => {
      const entity1 = mockWorkspaceUserEntityFactory({
        id: 'ws-u-1',
        createdBy: null,
      });
      const creator = mockUserFactory({ firstName: 'Admin' });
      const entity2 = mockWorkspaceUserEntityFactory({
        id: 'ws-u-2',
        createdBy: {
          id: 'creator-id',
          user: creator,
        } as unknown as WorkspaceUserEntity,
      });

      workspaceUserRepository.findByIdsAndWorkspaceId.mockResolvedValue([
        entity1,
        entity2,
      ]);

      const result =
        await service.findByIdsAndWorkspaceIdWithUserAndCreatedByUser({
          ids: ['user-1', 'user-2'],
          workspaceId: 'workspace-1',
        });

      expect(result).toHaveLength(2);
      expect(result?.[0].createdBy).toBeNull();
      expect(result?.[1].createdBy).toEqual({
        id: 'creator-id',
        firstName: creator.firstName,
        lastName: creator.lastName,
        profileImageUrl: creator.profileImageUrl,
      });
    });
  });

  describe('findAllByUserIdWithWorkspace', () => {
    it('returns list of workspace users with workspace relation', async () => {
      const mockEntity = mockWorkspaceUserEntityFactory();
      workspaceUserRepository.findAllByUserId.mockResolvedValue([mockEntity]);

      const result = await service.findAllByUserIdWithWorkspace('user-1');

      expect(workspaceUserRepository.findAllByUserId).toHaveBeenCalledWith({
        userId: 'user-1',
        relations: { workspace: true },
      });
      expect(result).toHaveLength(1);
    });
  });

  describe('findAllByUserId', () => {
    it('returns list of workspace users', async () => {
      const mockEntity = mockWorkspaceUserEntityFactory();
      workspaceUserRepository.findAllByUserId.mockResolvedValue([mockEntity]);

      const result = await service.findAllByUserId('user-1');

      expect(result).toHaveLength(1);
    });
  });

  describe('findAllByIds', () => {
    it('returns list of workspace users by ids', async () => {
      const mockEntity = mockWorkspaceUserEntityFactory();
      workspaceUserRepository.findAllByIds.mockResolvedValue([mockEntity]);

      const result = await service.findAllByIds({
        workspaceId: 'workspace-1',
        ids: ['ws-u-1'],
      });

      expect(result).toHaveLength(1);
    });
  });

  describe('findAllByWorkspaceId', () => {
    it('returns all users in workspace', async () => {
      const mockEntity = mockWorkspaceUserEntityFactory();
      workspaceUserRepository.findAllByWorkspaceId.mockResolvedValue([
        mockEntity,
      ]);

      const result = await service.findAllByWorkspaceId('workspace-1');

      expect(result).toHaveLength(1);
    });
  });

  describe('countManagers', () => {
    it('returns the count', async () => {
      workspaceUserRepository.countManagersInWorkspace.mockResolvedValue(5);

      const result = await service.countManagers('workspace-1');

      expect(result).toBe(5);
    });
  });

  describe('update', () => {
    it('throws NOT_FOUND if repository returns null', async () => {
      workspaceUserRepository.update.mockResolvedValue(null);

      await expect(
        service.update({
          id: 'ws-u-1',
          data: { workspaceRole: WorkspaceUserRole.MANAGER },
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });

    it('returns updated entity', async () => {
      const mockEntity = mockWorkspaceUserEntityFactory({
        workspaceRole: WorkspaceUserRole.MANAGER,
      });
      workspaceUserRepository.update.mockResolvedValue(mockEntity);

      const result = await service.update({
        id: 'ws-u-1',
        data: { workspaceRole: WorkspaceUserRole.MANAGER },
      });

      expect(workspaceUserRepository.update).toHaveBeenCalledWith({
        id: 'ws-u-1',
        data: { workspaceRole: WorkspaceUserRole.MANAGER },
        relations: { user: true },
      });
      expect(result.workspaceRole).toBe(WorkspaceUserRole.MANAGER);
    });
  });

  describe('delete', () => {
    it('throws NOT_FOUND if repository returns false', async () => {
      workspaceUserRepository.delete.mockResolvedValue(false);

      await expect(
        service.delete({
          workspaceId: 'ws-1',
          workspaceUserId: 'u-1',
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });

    it('resolves successfully if repository returns true', async () => {
      workspaceUserRepository.delete.mockResolvedValue(true);

      await expect(
        service.delete({
          workspaceId: 'ws-1',
          workspaceUserId: 'u-1',
        }),
      ).resolves.not.toThrow();
    });
  });

  describe('getLeaderboardData', () => {
    it('returns leaderboard response', async () => {
      const mockResponse = new WorkspaceLeaderboardResponse();
      mockResponse.id = 'ws-u-1';
      mockResponse.accumulatedPoints = 100;

      workspaceUserRepository.getWorkspaceLeaderboard.mockResolvedValue([
        mockResponse,
      ]);

      const result = await service.getLeaderboardData('workspace-1');

      expect(result).toHaveLength(1);
      expect(result[0].accumulatedPoints).toBe(100);
    });
  });
});
