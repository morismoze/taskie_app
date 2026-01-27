import { HttpStatus } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { DateTime } from 'luxon';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { AuthProvider } from 'src/modules/auth/core/domain/auth-provider.enum';
import { JwtPayload } from 'src/modules/auth/core/strategies/jwt-payload.type';
import { WorkspaceCore } from 'src/modules/workspace/workspace-module/domain/workspace-core.domain';
import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserWithWorkspaceCore } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-with-workspace.domain';
import { WorkspaceUserService } from 'src/modules/workspace/workspace-user-module/workspace-user.service';
import { WorkspaceService } from '../workspace/workspace-module/workspace.service';
import { UserStatus } from './domain/user-status.enum';
import { User } from './domain/user.domain';
import { UserEntity } from './persistence/user.entity';
import { UserRepository } from './persistence/user.repository';
import { UserService } from './user.service';

const mockUserFactory = (overrides?: Partial<User>): User =>
  ({
    id: 'user-1',
    email: 'test@example.com',
    firstName: 'John',
    lastName: 'Doe',
    socialId: 'social-123',
    provider: AuthProvider.GOOGLE,
    profileImageUrl: 'https://example.com/image.jpg',
    status: UserStatus.ACTIVE,
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
    ...overrides,
  }) as User;

const mockWorkspaceUserCoreFactory = (
  overrides?: Partial<WorkspaceUserWithWorkspaceCore>,
): WorkspaceUserWithWorkspaceCore =>
  ({
    id: 'workspace-user-1',
    workspaceRole: WorkspaceUserRole.MEMBER,
    workspace: {
      id: 'workspace-1',
      name: 'Test Workspace',
      createdAt: new Date(),
      updatedAt: new Date(),
      deletedAt: null,
    } as WorkspaceCore,
    ...overrides,
  }) as WorkspaceUserWithWorkspaceCore;

const createMockRepository = () => ({
  findById: jest.fn(),
  findByEmail: jest.fn(),
  findBySocialIdAndProvider: jest.fn(),
  create: jest.fn(),
  createVirtualUser: jest.fn(),
  update: jest.fn(),
  delete: jest.fn(),
});

const createMockWorkspaceUserService = () => ({
  findAllByUserId: jest.fn(),
  findAllByUserIdWithWorkspace: jest.fn(),
  countByWorkspace: jest.fn(),
});

const createMockWorkspaceService = () => ({
  delete: jest.fn(),
  softDelete: jest.fn(),
});

describe('UserService', () => {
  let service: UserService;
  let userRepository: ReturnType<typeof createMockRepository>;
  let workspaceUserService: ReturnType<typeof createMockWorkspaceUserService>;
  let workspaceService: ReturnType<typeof createMockWorkspaceService>;

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserService,
        {
          provide: UserRepository,
          useValue: createMockRepository(),
        },
        {
          provide: WorkspaceUserService,
          useValue: createMockWorkspaceUserService(),
        },
        {
          provide: WorkspaceService,
          useValue: createMockWorkspaceService(),
        },
      ],
    }).compile();

    service = module.get<UserService>(UserService);
    userRepository = module.get(UserRepository);
    workspaceUserService = module.get(WorkspaceUserService);
    workspaceService = module.get(WorkspaceService);
  });

  describe('create', () => {
    it('creates a new user with valid data', async () => {
      const newUser = mockUserFactory();
      userRepository.findByEmail.mockResolvedValue(null);
      userRepository.create.mockResolvedValue(newUser as UserEntity);

      const userData = {
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        socialId: 'social-123',
        provider: AuthProvider.GOOGLE,
        profileImageUrl: 'https://example.com/image.jpg',
        status: UserStatus.ACTIVE,
      };

      const result = await service.create(userData);

      expect(userRepository.findByEmail).toHaveBeenCalledWith(userData.email);
      expect(userRepository.create).toHaveBeenCalledWith(userData);
      expect(result).toEqual(newUser);
    });

    it('throws EMAIL_ALREADY_EXISTS if email is already registered', async () => {
      userRepository.findByEmail.mockResolvedValue(
        mockUserFactory() as UserEntity,
      );

      const userData = {
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        socialId: 'social-123',
        provider: AuthProvider.GOOGLE,
        profileImageUrl: 'https://example.com/image.jpg',
        status: UserStatus.ACTIVE,
      };

      await expect(service.create(userData)).rejects.toMatchObject({
        status: HttpStatus.UNPROCESSABLE_ENTITY,
        response: { code: ApiErrorCode.EMAIL_ALREADY_EXISTS },
      });
    });

    it('throws SERVER_ERROR if user creation fails', async () => {
      userRepository.findByEmail.mockResolvedValue(null);
      userRepository.create.mockResolvedValue(null);

      const userData = {
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        socialId: 'social-123',
        provider: AuthProvider.GOOGLE,
        profileImageUrl: 'https://example.com/image.jpg',
        status: UserStatus.ACTIVE,
      };

      await expect(service.create(userData)).rejects.toMatchObject({
        status: HttpStatus.INTERNAL_SERVER_ERROR,
        response: { code: ApiErrorCode.SERVER_ERROR },
      });
    });
  });

  describe('createVirtualUser', () => {
    it('creates a new virtual user with valid data', async () => {
      const virtualUser = mockUserFactory({
        email: null,
        provider: null,
        socialId: null,
      });
      userRepository.createVirtualUser.mockResolvedValue(
        virtualUser as UserEntity,
      );

      const userData = {
        firstName: 'Virtual',
        lastName: 'User',
        status: UserStatus.ACTIVE,
      };

      const result = await service.createVirtualUser(userData);

      expect(userRepository.createVirtualUser).toHaveBeenCalledWith(userData);
      expect(result).toEqual(virtualUser);
    });

    it('throws SERVER_ERROR if virtual user creation fails', async () => {
      userRepository.createVirtualUser.mockResolvedValue(null);

      const userData = {
        firstName: 'Virtual',
        lastName: 'User',
        status: UserStatus.ACTIVE,
      };

      await expect(service.createVirtualUser(userData)).rejects.toMatchObject({
        status: HttpStatus.INTERNAL_SERVER_ERROR,
        response: { code: ApiErrorCode.SERVER_ERROR },
      });
    });
  });

  describe('findById', () => {
    it('returns user by ID', async () => {
      const user = mockUserFactory();
      userRepository.findById.mockResolvedValue(user as UserEntity);

      const result = await service.findById('user-1');

      expect(userRepository.findById).toHaveBeenCalledWith('user-1');
      expect(result).toEqual(user);
    });

    it('returns null if user not found', async () => {
      userRepository.findById.mockResolvedValue(null);

      const result = await service.findById('non-existent-user');

      expect(result).toBeNull();
    });
  });

  describe('findByEmail', () => {
    it('returns user by email', async () => {
      const user = mockUserFactory();
      userRepository.findByEmail.mockResolvedValue(user as UserEntity);

      const result = await service.findByEmail('test@example.com');

      expect(userRepository.findByEmail).toHaveBeenCalledWith(
        'test@example.com',
      );
      expect(result).toEqual(user);
    });

    it('returns null if user not found', async () => {
      userRepository.findByEmail.mockResolvedValue(null);

      const result = await service.findByEmail('nonexistent@example.com');

      expect(result).toBeNull();
    });
  });

  describe('findBySocialIdAndProvider', () => {
    it('returns user by social ID and provider', async () => {
      const user = mockUserFactory();
      userRepository.findBySocialIdAndProvider.mockResolvedValue(
        user as UserEntity,
      );

      const result = await service.findBySocialIdAndProvider({
        socialId: 'social-123',
        provider: AuthProvider.GOOGLE,
      });

      expect(userRepository.findBySocialIdAndProvider).toHaveBeenCalledWith({
        socialId: 'social-123',
        provider: AuthProvider.GOOGLE,
      });
      expect(result).toEqual(user);
    });

    it('returns null if user not found', async () => {
      userRepository.findBySocialIdAndProvider.mockResolvedValue(null);

      const result = await service.findBySocialIdAndProvider({
        socialId: 'non-existent',
        provider: AuthProvider.GOOGLE,
      });

      expect(result).toBeNull();
    });
  });

  describe('me', () => {
    it('returns user response with roles', async () => {
      const user = mockUserFactory();
      const workspaceUser = mockWorkspaceUserCoreFactory({
        workspaceRole: WorkspaceUserRole.MANAGER,
      });

      userRepository.findById.mockResolvedValue(user as UserEntity);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        workspaceUser,
      ]);

      const jwtPayload: JwtPayload = {
        sub: 'user-1',
        atv: 0,
        roles: [],
        sessionId: 'session-1',
      };

      const result = await service.me(jwtPayload);

      expect(userRepository.findById).toHaveBeenCalledWith('user-1');
      expect(
        workspaceUserService.findAllByUserIdWithWorkspace,
      ).toHaveBeenCalledWith('user-1');
      expect(result).toEqual({
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        profileImageUrl: user.profileImageUrl,
        roles: [
          {
            workspaceId: workspaceUser.workspace.id,
            role: WorkspaceUserRole.MANAGER,
          },
        ],
        createdAt: DateTime.fromJSDate(user.createdAt).toISO(),
      });
    });

    it('returns user response with multiple roles', async () => {
      const user = mockUserFactory();
      const wsUser1 = mockWorkspaceUserCoreFactory({
        workspace: { id: 'ws-1' } as WorkspaceCore,
        workspaceRole: WorkspaceUserRole.MANAGER,
      });
      const wsUser2 = mockWorkspaceUserCoreFactory({
        workspace: { id: 'ws-2' } as WorkspaceCore,
        workspaceRole: WorkspaceUserRole.MEMBER,
      });

      userRepository.findById.mockResolvedValue(user as UserEntity);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        wsUser1,
        wsUser2,
      ]);

      const jwtPayload: JwtPayload = {
        sub: 'user-1',
        atv: 0,
        roles: [],
        sessionId: 'session-1',
      };

      const result = await service.me(jwtPayload);

      expect(result.roles).toHaveLength(2);
      expect(result.roles).toEqual([
        { workspaceId: 'ws-1', role: WorkspaceUserRole.MANAGER },
        { workspaceId: 'ws-2', role: WorkspaceUserRole.MEMBER },
      ]);
    });

    it('returns empty roles if user is not in any workspace', async () => {
      const user = mockUserFactory();
      userRepository.findById.mockResolvedValue(user as UserEntity);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([]);

      const jwtPayload: JwtPayload = {
        sub: 'user-1',
        atv: 0,
        roles: [],
        sessionId: 'session-1',
      };

      const result = await service.me(jwtPayload);

      expect(result.roles).toEqual([]);
    });
  });

  describe('update', () => {
    it('updates user with new data', async () => {
      const user = mockUserFactory();
      const updatedUser = { ...user, firstName: 'Jane' };

      userRepository.findById.mockResolvedValue(user as UserEntity);
      userRepository.update.mockResolvedValue(updatedUser as UserEntity);

      const result = await service.update({
        id: 'user-1',
        data: { firstName: 'Jane' },
      });

      expect(userRepository.update).toHaveBeenCalledWith({
        id: 'user-1',
        data: { firstName: 'Jane' },
      });
      expect(result.firstName).toBe('Jane');
    });

    it('throws INVALID_PAYLOAD if user not found', async () => {
      userRepository.findById.mockResolvedValue(null);

      await expect(
        service.update({
          id: 'non-existent',
          data: { firstName: 'Jane' },
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });

    it('throws EMAIL_ALREADY_EXISTS if new email is taken', async () => {
      const user = mockUserFactory({ id: 'user-1' });
      const otherUser = mockUserFactory({
        id: 'user-2',
        email: 'taken@example.com',
      });

      userRepository.findById.mockResolvedValue(user as UserEntity);
      userRepository.findByEmail.mockResolvedValue(otherUser as UserEntity);

      await expect(
        service.update({
          id: 'user-1',
          data: { email: 'taken@example.com' },
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.CONFLICT,
        response: { code: ApiErrorCode.EMAIL_ALREADY_EXISTS },
      });
    });

    it('allows update if email belongs to self', async () => {
      const user = mockUserFactory({
        id: 'user-1',
        email: 'my@example.com',
      });

      userRepository.findById.mockResolvedValue(user as UserEntity);
      userRepository.findByEmail.mockResolvedValue(user as UserEntity);
      userRepository.update.mockResolvedValue(user as UserEntity);

      await expect(
        service.update({
          id: 'user-1',
          data: { email: 'my@example.com' },
        }),
      ).resolves.not.toThrow();
    });

    it('throws INVALID_PAYLOAD if update returns null', async () => {
      const user = mockUserFactory();
      userRepository.findById.mockResolvedValue(user as UserEntity);
      userRepository.update.mockResolvedValue(null);

      await expect(
        service.update({
          id: 'user-1',
          data: { firstName: 'Jane' },
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });
  });

  describe('delete', () => {
    it('deletes user successfully when user is just a MEMBER', async () => {
      // Setup: User is member in one workspace
      const memberWsUser = mockWorkspaceUserCoreFactory({
        workspaceRole: WorkspaceUserRole.MEMBER,
      });
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        memberWsUser,
      ]);
      userRepository.delete.mockResolvedValue(true);

      await service.delete('user-1');

      // Assert: No checks for manager logic, straight to delete
      expect(workspaceUserService.countByWorkspace).not.toHaveBeenCalled();
      expect(workspaceService.delete).not.toHaveBeenCalled();
      expect(userRepository.delete).toHaveBeenCalledWith('user-1');
    });

    it('deletes user successfully if user is MANAGER but other managers exist', async () => {
      // Setup: User is Manager
      const managerWsUser = mockWorkspaceUserCoreFactory({
        workspaceRole: WorkspaceUserRole.MANAGER,
        workspace: { id: 'ws-1' } as WorkspaceCore,
      });
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        managerWsUser,
      ]);

      // Mock: There ARE other managers (count > 0)
      workspaceUserService.countByWorkspace.mockResolvedValueOnce(1);

      userRepository.delete.mockResolvedValue(true);

      await service.delete('user-1');

      // Assert
      expect(workspaceUserService.countByWorkspace).toHaveBeenCalledWith(
        'ws-1',
        { role: WorkspaceUserRole.MANAGER, excludeUserId: 'user-1' },
      );
      // Should NOT check for real users because other manager exists
      expect(workspaceUserService.countByWorkspace).toHaveBeenCalledTimes(1);
      // Should NOT delete workspace
      expect(workspaceService.delete).not.toHaveBeenCalled();
      // Should delete user
      expect(userRepository.delete).toHaveBeenCalledWith('user-1');
    });

    it('throws SOLE_MANAGER_CONFLICT if user is SOLE MANAGER and other REAL USERS exist', async () => {
      // Setup: User is Manager
      const managerWsUser = mockWorkspaceUserCoreFactory({
        workspaceRole: WorkspaceUserRole.MANAGER,
        workspace: { id: 'ws-1' } as WorkspaceCore,
      });
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        managerWsUser,
      ]);

      // Mock 1: No other managers (count = 0)
      workspaceUserService.countByWorkspace.mockResolvedValueOnce(0);
      // Mock 2: Yes other real users (count = 1)
      workspaceUserService.countByWorkspace.mockResolvedValueOnce(1);

      await expect(service.delete('user-1')).rejects.toMatchObject({
        status: HttpStatus.CONFLICT,
        response: { code: ApiErrorCode.SOLE_MANAGER_CONFLICT },
      });

      // Assert
      expect(workspaceUserService.countByWorkspace).toHaveBeenCalledTimes(2);
      expect(workspaceService.delete).not.toHaveBeenCalled();
      expect(userRepository.delete).not.toHaveBeenCalled();
    });

    it('deletes WORKSPACE and USER if user is SOLE MANAGER and NO other real users exist', async () => {
      // Setup: User is Manager
      const managerWsUser = mockWorkspaceUserCoreFactory({
        workspaceRole: WorkspaceUserRole.MANAGER,
        workspace: { id: 'ws-1' } as WorkspaceCore,
      });
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        managerWsUser,
      ]);

      // Mock 1: No other managers
      workspaceUserService.countByWorkspace.mockResolvedValueOnce(0);
      // Mock 2: No other real users (only virtuals or empty)
      workspaceUserService.countByWorkspace.mockResolvedValueOnce(0);

      userRepository.delete.mockResolvedValue(true);

      await service.delete('user-1');

      // Assert
      expect(workspaceService.delete).toHaveBeenCalledWith('ws-1'); // Workspace destroyed
      expect(userRepository.delete).toHaveBeenCalledWith('user-1'); // User deleted
    });

    it('throws INVALID_PAYLOAD if user deletion fails in repo', async () => {
      // Setup: Member (skip logic)
      const memberWsUser = mockWorkspaceUserCoreFactory({
        workspaceRole: WorkspaceUserRole.MEMBER,
      });
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        memberWsUser,
      ]);
      userRepository.delete.mockResolvedValue(false);

      await expect(service.delete('user-1')).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });
  });
});
