import { HttpStatus } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { DateTime } from 'luxon';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { AuthProvider } from 'src/modules/auth/core/domain/auth-provider.enum';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { UserStatus } from 'src/modules/user/domain/user-status.enum';
import { User } from 'src/modules/user/domain/user.domain';
import { WorkspaceCore } from '../workspace-module/domain/workspace-core.domain';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUser } from '../workspace-user-module/domain/workspace-user.domain';
import { WorkspaceUserEntity } from '../workspace-user-module/persistence/workspace-user.entity';
import { WorkspaceUserService } from '../workspace-user-module/workspace-user.service';
import { TransactionalWorkspaceInviteRepository } from './persistence/transactional/transactional-workspace-invite.repository';
import { WorkspaceInviteEntity } from './persistence/workspace-invite.entity';
import { WorkspaceInviteService } from './workspace-invite.service';

const mockUserFactory = (overrides?: Partial<User>): User =>
  ({
    id: 'user-1',
    email: 'john.doe@example.com',
    firstName: 'John',
    lastName: 'Doe',
    profileImageUrl: null,
    provider: AuthProvider.GOOGLE,
    socialId: 'google-123',
    status: UserStatus.ACTIVE,
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
    ...overrides,
  }) as User;

const mockWorkspaceFactory = (overrides?: Partial<WorkspaceCore>) => ({
  id: 'workspace-1',
  name: 'Test Workspace',
  pictureUrl: null,
  description: 'A test workspace',
  createdAt: new Date(),
  updatedAt: new Date(),
  deletedAt: null,
  ...overrides,
});

const mockWorkspaceUserFactory = (overrides?: Partial<WorkspaceUser>) =>
  ({
    id: 'workspace-user-1',
    workspaceRole: WorkspaceUserRole.MEMBER,
    user: mockUserFactory(),
    workspace: mockWorkspaceFactory(),
    ...overrides,
  }) as WorkspaceUser;

const mockWorkspaceInviteEntityFactory = (
  overrides?: Partial<WorkspaceInviteEntity>,
): WorkspaceInviteEntity => {
  const base = {
    id: 'invite-1',
    token: 'test-token-123',
    expiresAt: DateTime.now().plus({ hours: 24 }).toJSDate(),
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
    workspaceId: 'workspace-1',
    workspace: {
      ...mockWorkspaceFactory(),
      createdBy: mockUserFactory(),
    },
    createdById: 'user-1',
    createdBy: {
      id: 'ws-user-creator',
      user: mockUserFactory({ id: 'user-1' }),
    },
    usedById: null,
    usedBy: null,
    ...overrides,
  };

  return base as unknown as WorkspaceInviteEntity;
};

const createMockRepository = () => ({
  create: jest.fn(),
  findByToken: jest.fn(),
  markUsedBy: jest.fn(),
});

const createMockWorkspaceUserService = () => ({
  create: jest.fn(),
  findByUserIdAndWorkspaceId: jest.fn(),
});

const createMockUnitOfWorkService = () => ({
  withTransaction: jest.fn().mockImplementation(async (cb) => {
    await Promise.resolve();
    return cb();
  }),
});

describe('WorkspaceInviteService', () => {
  let service: WorkspaceInviteService;
  let workspaceInviteRepository: ReturnType<typeof createMockRepository>;
  let workspaceUserService: jest.Mocked<WorkspaceUserService>;
  let unitOfWorkService: jest.Mocked<UnitOfWorkService>;

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        WorkspaceInviteService,
        {
          provide: TransactionalWorkspaceInviteRepository,
          useValue: createMockRepository(),
        },
        {
          provide: WorkspaceUserService,
          useValue: createMockWorkspaceUserService(),
        },
        {
          provide: UnitOfWorkService,
          useValue: createMockUnitOfWorkService(),
        },
      ],
    }).compile();

    service = module.get<WorkspaceInviteService>(WorkspaceInviteService);
    workspaceInviteRepository = module.get(
      TransactionalWorkspaceInviteRepository,
    );
    workspaceUserService = module.get(
      WorkspaceUserService,
    ) as jest.Mocked<WorkspaceUserService>;
    unitOfWorkService = module.get(
      UnitOfWorkService,
    ) as jest.Mocked<UnitOfWorkService>;
  });

  describe('createInviteToken', () => {
    it('creates a new invite token with correct expiration', async () => {
      const mockInvite = mockWorkspaceInviteEntityFactory();
      workspaceInviteRepository.create.mockResolvedValue(mockInvite);

      const result = await service.createInviteToken({
        workspaceId: 'workspace-1',
        createdByWorkspaceUserId: 'user-1',
      });

      expect(workspaceInviteRepository.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          workspaceId: 'workspace-1',
          createdById: 'user-1',
          expiresAt: expect.any(String),
        }),
      });
      expect(result).toEqual(mockInvite);
    });

    it('generates unique token for each invite', async () => {
      const mockInvite = mockWorkspaceInviteEntityFactory();
      workspaceInviteRepository.create.mockResolvedValue(mockInvite);

      await service.createInviteToken({
        workspaceId: 'workspace-1',
        createdByWorkspaceUserId: 'user-1',
      });

      const callArgs = workspaceInviteRepository.create.mock.calls[0][0];
      expect(callArgs.data.token).toBeDefined();
      expect(typeof callArgs.data.token).toBe('string');
      expect(callArgs.data.token.length).toBeGreaterThan(0);
    });

    it('sets expiration to 7 days from now', async () => {
      const mockInvite = mockWorkspaceInviteEntityFactory();
      workspaceInviteRepository.create.mockResolvedValue(mockInvite);

      const beforeCall = DateTime.now().toUTC();
      await service.createInviteToken({
        workspaceId: 'workspace-1',
        createdByWorkspaceUserId: 'user-1',
      });

      const callArgs = workspaceInviteRepository.create.mock.calls[0][0];
      const expiresAt = DateTime.fromISO(callArgs.data.expiresAt);

      const diffInDays = expiresAt.diff(beforeCall, 'days').toObject().days;
      expect(diffInDays).toEqual(7);
    });

    it('throws SERVER_ERROR if invite creation fails', async () => {
      workspaceInviteRepository.create.mockResolvedValue(null);

      await expect(
        service.createInviteToken({
          workspaceId: 'workspace-1',
          createdByWorkspaceUserId: 'user-1',
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.INTERNAL_SERVER_ERROR,
        response: { code: ApiErrorCode.SERVER_ERROR },
      });
    });
  });

  describe('findByTokenWithWorkspace', () => {
    it('returns workspace invite with workspace data', async () => {
      const mockInvite = mockWorkspaceInviteEntityFactory();
      workspaceInviteRepository.findByToken.mockResolvedValue(mockInvite);

      const result = await service.findByTokenWithWorkspace('test-token-123');

      expect(workspaceInviteRepository.findByToken).toHaveBeenCalledWith({
        token: 'test-token-123',
        relations: {
          workspace: {
            createdBy: true,
          },
        },
      });
      expect(result).toEqual(mockInvite);
    });

    it('returns null if invite not found', async () => {
      workspaceInviteRepository.findByToken.mockResolvedValue(null);

      const result = await service.findByTokenWithWorkspace('invalid-token');

      expect(result).toBeNull();
    });
  });

  describe('findByTokenWithWorkspaceAndUser', () => {
    it('returns workspace invite with workspace, createdBy, and usedBy data', async () => {
      const mockInvite = mockWorkspaceInviteEntityFactory({
        usedBy: {
          id: 'ws-user-2',
          user: mockUserFactory({ id: 'user-2' }),
        } as unknown as WorkspaceUserEntity,
      });

      workspaceInviteRepository.findByToken.mockResolvedValue(mockInvite);

      const result =
        await service.findByTokenWithWorkspaceAndUser('test-token-123');

      expect(workspaceInviteRepository.findByToken).toHaveBeenCalledWith({
        token: 'test-token-123',
        relations: {
          workspace: true,
          createdBy: true,
          usedBy: true,
        },
      });
      expect(result).toEqual(mockInvite);
    });

    it('returns null if invite not found', async () => {
      workspaceInviteRepository.findByToken.mockResolvedValue(null);

      const result =
        await service.findByTokenWithWorkspaceAndUser('invalid-token');

      expect(result).toBeNull();
    });
  });

  describe('claimInvite', () => {
    it('claims invite successfully for new user', async () => {
      const mockInvite = mockWorkspaceInviteEntityFactory();
      const mockCreatedUser = mockWorkspaceUserFactory();
      const mockUpdatedInvite = mockWorkspaceInviteEntityFactory({
        usedBy: {
          id: mockCreatedUser.id,
          user: mockUserFactory(),
        } as unknown as WorkspaceUserEntity,
      });

      workspaceInviteRepository.findByToken.mockResolvedValue(mockInvite);
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(null);
      workspaceUserService.create.mockResolvedValue(mockCreatedUser as any);
      workspaceInviteRepository.markUsedBy.mockResolvedValue(mockUpdatedInvite);

      (unitOfWorkService.withTransaction as jest.Mock).mockImplementation(
        async (work) => await work(),
      );

      const result = await service.claimInvite({
        token: 'test-token-123',
        usedById: 'user-2',
      });

      expect(workspaceUserService.create).toHaveBeenCalledWith({
        workspaceId: mockInvite.workspace.id,
        userId: 'user-2',
        createdById: mockInvite.createdBy!.id,
        workspaceRole: WorkspaceUserRole.MEMBER,
      });

      expect(workspaceInviteRepository.markUsedBy).toHaveBeenCalledWith({
        id: mockInvite.id,
        usedById: mockCreatedUser.id,
        relations: {
          workspace: {
            createdBy: true,
          },
        },
      });

      expect(result).toEqual(mockUpdatedInvite);
    });

    it('claims invite correctly when createdBy is null', async () => {
      const mockInvite = mockWorkspaceInviteEntityFactory({ createdBy: null });
      const mockCreatedUser = mockWorkspaceUserFactory();
      const mockUpdatedInvite = mockWorkspaceInviteEntityFactory();

      workspaceInviteRepository.findByToken.mockResolvedValue(mockInvite);
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(null);
      workspaceUserService.create.mockResolvedValue(mockCreatedUser as any);
      workspaceInviteRepository.markUsedBy.mockResolvedValue(mockUpdatedInvite);

      (unitOfWorkService.withTransaction as jest.Mock).mockImplementation(
        async (work) => await work(),
      );

      await service.claimInvite({
        token: 'test-token-123',
        usedById: 'user-2',
      });

      expect(workspaceUserService.create).toHaveBeenCalledWith(
        expect.objectContaining({
          createdById: null,
        }),
      );
    });

    it('throws NOT_FOUND_WORKSPACE_INVITE_TOKEN if invite does not exist', async () => {
      workspaceInviteRepository.findByToken.mockResolvedValue(null);

      await expect(
        service.claimInvite({
          token: 'invalid-token',
          usedById: 'user-2',
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.NOT_FOUND_WORKSPACE_INVITE_TOKEN },
      });
    });

    it('throws WORKSPACE_INVITE_EXISTING_USER if user already in workspace', async () => {
      const mockInvite = mockWorkspaceInviteEntityFactory();
      const existingUser = mockWorkspaceUserFactory();

      workspaceInviteRepository.findByToken.mockResolvedValue(mockInvite);
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(
        existingUser,
      );

      await expect(
        service.claimInvite({
          token: 'test-token-123',
          usedById: 'user-2',
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.BAD_REQUEST,
        response: { code: ApiErrorCode.WORKSPACE_INVITE_EXISTING_USER },
      });
    });

    it('throws WORKSPACE_INVITE_ALREADY_USED if invite was already used', async () => {
      const usedInvite = mockWorkspaceInviteEntityFactory({
        usedBy: { id: 'some-user' } as unknown as WorkspaceUserEntity,
      });

      workspaceInviteRepository.findByToken.mockResolvedValue(usedInvite);
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(null);

      await expect(
        service.claimInvite({
          token: 'test-token-123',
          usedById: 'user-2',
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.BAD_REQUEST,
        response: { code: ApiErrorCode.WORKSPACE_INVITE_ALREADY_USED },
      });
    });

    it('throws WORKSPACE_INVITE_EXPIRED if invite has expired', async () => {
      const expiredInvite = mockWorkspaceInviteEntityFactory({
        expiresAt: DateTime.now().minus({ hours: 1 }).toJSDate(),
      });

      workspaceInviteRepository.findByToken.mockResolvedValue(expiredInvite);
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(null);

      await expect(
        service.claimInvite({
          token: 'test-token-123',
          usedById: 'user-2',
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.BAD_REQUEST,
        response: { code: ApiErrorCode.WORKSPACE_INVITE_EXPIRED },
      });
    });

    it('throws INVALID_PAYLOAD if marking invite as used fails', async () => {
      const mockInvite = mockWorkspaceInviteEntityFactory();
      const mockCreatedUser = mockWorkspaceUserFactory();

      workspaceInviteRepository.findByToken.mockResolvedValue(mockInvite);
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(null);
      workspaceUserService.create.mockResolvedValue(mockCreatedUser as any);
      workspaceInviteRepository.markUsedBy.mockResolvedValue(null);

      (unitOfWorkService.withTransaction as jest.Mock).mockImplementation(
        async (work) => await work(),
      );

      await expect(
        service.claimInvite({
          token: 'test-token-123',
          usedById: 'user-2',
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });

    it('invite valid exactly at expiration time edge case', async () => {
      const expiresAt = DateTime.now().toUTC().plus({ seconds: 1 });
      const mockInvite = mockWorkspaceInviteEntityFactory({
        expiresAt: expiresAt.toJSDate(),
      });
      const mockCreatedUser = mockWorkspaceUserFactory();
      const mockUpdatedInvite = mockWorkspaceInviteEntityFactory();

      workspaceInviteRepository.findByToken.mockResolvedValue(mockInvite);
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(null);
      workspaceUserService.create.mockResolvedValue(mockCreatedUser as any);
      workspaceInviteRepository.markUsedBy.mockResolvedValue(mockUpdatedInvite);

      (unitOfWorkService.withTransaction as jest.Mock).mockImplementation(
        async (work) => await work(),
      );

      const result = await service.claimInvite({
        token: 'test-token-123',
        usedById: 'user-2',
      });

      expect(result).toBeDefined();
    });

    it('wraps operations in transaction', async () => {
      const mockInvite = mockWorkspaceInviteEntityFactory();
      workspaceInviteRepository.findByToken.mockResolvedValue(mockInvite);
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(null);
      workspaceUserService.create.mockResolvedValue(
        mockWorkspaceUserFactory() as any,
      );
      workspaceInviteRepository.markUsedBy.mockResolvedValue(
        mockWorkspaceInviteEntityFactory(),
      );

      (unitOfWorkService.withTransaction as jest.Mock).mockImplementation(
        async (work) => await work(),
      );

      await service.claimInvite({
        token: 'test-token-123',
        usedById: 'user-2',
      });

      expect(unitOfWorkService.withTransaction).toHaveBeenCalled();
    });
  });
});
