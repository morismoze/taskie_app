import { HttpStatus } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { DateTime } from 'luxon';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { AuthProvider } from 'src/modules/auth/core/domain/auth-provider.enum';
import { JwtPayload } from 'src/modules/auth/core/strategies/jwt-payload.type';
import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserService } from 'src/modules/workspace/workspace-user-module/workspace-user.service';
import { UserStatus } from './domain/user-status.enum';
import { User } from './domain/user.domain';
import { UserEntity } from './persistence/user.entity';
import { UserRepository } from './persistence/user.repository';
import { UserService } from './user.service';

describe('UserService', () => {
  let service: UserService;
  let userRepository: jest.Mocked<UserRepository>;
  let workspaceUserService: jest.Mocked<WorkspaceUserService>;

  const mockUser: User = {
    id: 'user-1',
    email: 'test@example.com',
    firstName: 'John',
    lastName: 'Doe',
    socialId: 'social-123',
    provider: AuthProvider.GOOGLE,
    profileImageUrl: 'https://example.com/image.jpg',
    status: UserStatus.ACTIVE,
    createdAt: new Date('2024-01-01'),
    updatedAt: new Date('2024-01-01'),
    deletedAt: null,
  };

  const mockVirtualUser: User = {
    id: 'virtual-user-1',
    email: null,
    firstName: 'Virtual',
    lastName: 'User',
    socialId: null,
    provider: null,
    profileImageUrl: null,
    status: UserStatus.ACTIVE,
    createdAt: new Date('2024-01-01'),
    updatedAt: new Date('2024-01-01'),
    deletedAt: null,
  };

  const mockWorkspaceUser = {
    id: 'workspace-user-1',
    workspaceRole: WorkspaceUserRole.MANAGER,
    workspace: {
      id: 'workspace-1',
      name: 'Test Workspace',
      createdAt: new Date('2024-01-01'),
      updatedAt: new Date('2024-01-01'),
      deletedAt: null,
    },
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserService,
        {
          provide: UserRepository,
          useValue: {
            findById: jest.fn(),
            findByEmail: jest.fn(),
            findBySocialIdAndProvider: jest.fn(),
            create: jest.fn(),
            createVirtualUser: jest.fn(),
            update: jest.fn(),
            delete: jest.fn(),
          },
        },
        {
          provide: WorkspaceUserService,
          useValue: {
            findAllByUserId: jest.fn(),
            findAllByUserIdWithWorkspace: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<UserService>(UserService);
    userRepository = module.get(UserRepository) as jest.Mocked<UserRepository>;
    workspaceUserService = module.get(
      WorkspaceUserService,
    ) as jest.Mocked<WorkspaceUserService>;
  });

  describe('create', () => {
    it('creates a new user with valid data', async () => {
      userRepository.findByEmail.mockResolvedValue(null);
      userRepository.create.mockResolvedValue(mockUser as UserEntity);

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
      expect(result).toEqual(mockUser);
    });

    it('throws EMAIL_ALREADY_EXISTS if email is already registered', async () => {
      userRepository.findByEmail.mockResolvedValue(mockUser as UserEntity);

      const userData = {
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        socialId: 'social-123',
        provider: AuthProvider.GOOGLE,
        profileImageUrl: 'https://example.com/image.jpg',
        status: UserStatus.ACTIVE,
      };

      try {
        await service.create(userData);
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.UNPROCESSABLE_ENTITY,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.EMAIL_ALREADY_EXISTS,
        });
      }
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

      try {
        await service.create(userData);
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.INTERNAL_SERVER_ERROR,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.SERVER_ERROR,
        });
      }
    });
  });

  describe('createVirtualUser', () => {
    it('creates a new virtual user with valid data', async () => {
      userRepository.createVirtualUser.mockResolvedValue(
        mockVirtualUser as UserEntity,
      );

      const userData = {
        firstName: 'Virtual',
        lastName: 'User',
        status: UserStatus.ACTIVE,
      };

      const result = await service.createVirtualUser(userData);

      expect(userRepository.createVirtualUser).toHaveBeenCalledWith(userData);
      expect(result).toEqual(mockVirtualUser);
    });

    it('throws SERVER_ERROR if virtual user creation fails', async () => {
      userRepository.createVirtualUser.mockResolvedValue(null);

      const userData = {
        firstName: 'Virtual',
        lastName: 'User',
        status: UserStatus.ACTIVE,
      };

      try {
        await service.createVirtualUser(userData);
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.INTERNAL_SERVER_ERROR,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.SERVER_ERROR,
        });
      }
    });
  });

  describe('findById', () => {
    it('returns user by ID', async () => {
      userRepository.findById.mockResolvedValue(mockUser as UserEntity);

      const result = await service.findById('user-1');

      expect(userRepository.findById).toHaveBeenCalledWith('user-1');
      expect(result).toEqual(mockUser);
    });

    it('returns null if user not found', async () => {
      userRepository.findById.mockResolvedValue(null);

      const result = await service.findById('non-existent-user');

      expect(result).toBeNull();
    });
  });

  describe('findByEmail', () => {
    it('returns user by email', async () => {
      userRepository.findByEmail.mockResolvedValue(mockUser as UserEntity);

      const result = await service.findByEmail('test@example.com');

      expect(userRepository.findByEmail).toHaveBeenCalledWith(
        'test@example.com',
      );
      expect(result).toEqual(mockUser);
    });

    it('returns null if user not found', async () => {
      userRepository.findByEmail.mockResolvedValue(null);

      const result = await service.findByEmail('nonexistent@example.com');

      expect(result).toBeNull();
    });
  });

  describe('findBySocialIdAndProvider', () => {
    it('returns user by social ID and provider', async () => {
      userRepository.findBySocialIdAndProvider.mockResolvedValue(
        mockUser as UserEntity,
      );

      const result = await service.findBySocialIdAndProvider({
        socialId: 'social-123',
        provider: AuthProvider.GOOGLE,
      });

      expect(userRepository.findBySocialIdAndProvider).toHaveBeenCalledWith({
        socialId: 'social-123',
        provider: AuthProvider.GOOGLE,
      });
      expect(result).toEqual(mockUser);
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
      userRepository.findById.mockResolvedValue(mockUser as UserEntity);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        mockWorkspaceUser as any,
      ]);

      const jwtPayload: JwtPayload = {
        sub: 'user-1',
        atv: 0,
        roles: [
          {
            workspaceId: 'workspace-1',
            role: WorkspaceUserRole.MANAGER,
          },
        ],
        sessionId: 'session-1',
      };

      const result = await service.me(jwtPayload);

      expect(userRepository.findById).toHaveBeenCalledWith('user-1');
      expect(
        workspaceUserService.findAllByUserIdWithWorkspace,
      ).toHaveBeenCalledWith('user-1');
      expect(result).toEqual({
        id: mockUser.id,
        email: mockUser.email,
        firstName: mockUser.firstName,
        lastName: mockUser.lastName,
        profileImageUrl: mockUser.profileImageUrl,
        roles: [
          {
            workspaceId: 'workspace-1',
            role: WorkspaceUserRole.MANAGER,
          },
        ],
        createdAt: DateTime.fromJSDate(mockUser.createdAt).toISO(),
      });
    });

    it('returns user response with multiple roles', async () => {
      const secondWorkspaceUser = {
        ...mockWorkspaceUser,
        id: 'workspace-user-2',
        workspaceRole: WorkspaceUserRole.MEMBER,
        workspace: {
          id: 'workspace-2',
          name: 'Second Workspace',
          createdAt: new Date('2024-01-01'),
          updatedAt: new Date('2024-01-01'),
          deletedAt: null,
        },
      };

      userRepository.findById.mockResolvedValue(mockUser as UserEntity);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        mockWorkspaceUser as any,
        secondWorkspaceUser as any,
      ]);

      const jwtPayload: JwtPayload = {
        sub: 'user-1',
        atv: 0,
        roles: [
          {
            workspaceId: 'workspace-1',
            role: WorkspaceUserRole.MANAGER,
          },
          {
            workspaceId: 'workspace-2',
            role: WorkspaceUserRole.MEMBER,
          },
        ],
        sessionId: 'session-1',
      };

      const result = await service.me(jwtPayload);

      expect(result.roles).toHaveLength(2);
      expect(result.roles).toEqual([
        { workspaceId: 'workspace-1', role: WorkspaceUserRole.MANAGER },
        { workspaceId: 'workspace-2', role: WorkspaceUserRole.MEMBER },
      ]);
    });

    it('returns user response with no roles if user is not in any workspace', async () => {
      userRepository.findById.mockResolvedValue(mockUser as UserEntity);
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
      userRepository.findById.mockResolvedValue(mockUser as UserEntity);
      userRepository.update.mockResolvedValue({
        ...mockUser,
        firstName: 'Jane',
      } as UserEntity);

      const result = await service.update({
        id: 'user-1',
        data: { firstName: 'Jane' },
      });

      expect(userRepository.findById).toHaveBeenCalledWith('user-1');
      expect(userRepository.update).toHaveBeenCalledWith({
        id: 'user-1',
        data: { firstName: 'Jane' },
      });
      expect(result.firstName).toBe('Jane');
    });

    it('throws INVALID_PAYLOAD if user not found', async () => {
      userRepository.findById.mockResolvedValue(null);

      try {
        await service.update({
          id: 'non-existent',
          data: { firstName: 'Jane' },
        });
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.NOT_FOUND,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.INVALID_PAYLOAD,
        });
      }
    });

    it('throws EMAIL_ALREADY_EXISTS if new email is already taken by another user', async () => {
      userRepository.findById.mockResolvedValue(mockUser as UserEntity);
      const otherUser = { ...mockUser, id: 'user-2' };
      userRepository.findByEmail.mockResolvedValue(otherUser as UserEntity);

      try {
        await service.update({
          id: 'user-1',
          data: { email: 'other@example.com' },
        });
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.CONFLICT,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.EMAIL_ALREADY_EXISTS,
        });
      }
    });

    it('allows update without email change', async () => {
      userRepository.findById.mockResolvedValue(mockUser as UserEntity);
      userRepository.update.mockResolvedValue({
        ...mockUser,
        firstName: 'Jane',
        lastName: 'Smith',
      } as UserEntity);

      const result = await service.update({
        id: 'user-1',
        data: { firstName: 'Jane', lastName: 'Smith' },
      });

      expect(userRepository.findByEmail).not.toHaveBeenCalled();
      expect(userRepository.update).toHaveBeenCalled();
      expect(result).toEqual({
        ...mockUser,
        firstName: 'Jane',
        lastName: 'Smith',
      });
    });

    it('throws INVALID_PAYLOAD if user is deleted during update', async () => {
      userRepository.findById.mockResolvedValue(mockUser as UserEntity);
      userRepository.update.mockResolvedValue(null);

      try {
        await service.update({
          id: 'user-1',
          data: { firstName: 'Jane' },
        });
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.NOT_FOUND,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.INVALID_PAYLOAD,
        });
      }
    });

    it('updates multiple fields at once', async () => {
      const updatedUser = {
        ...mockUser,
        firstName: 'Jane',
        lastName: 'Smith',
        profileImageUrl: 'https://example.com/new-image.jpg',
      };
      userRepository.findById.mockResolvedValue(mockUser as UserEntity);
      userRepository.update.mockResolvedValue(updatedUser as UserEntity);

      const result = await service.update({
        id: 'user-1',
        data: {
          firstName: 'Jane',
          lastName: 'Smith',
          profileImageUrl: 'https://example.com/new-image.jpg',
        },
      });

      expect(result.firstName).toBe('Jane');
      expect(result.lastName).toBe('Smith');
      expect(result.profileImageUrl).toBe('https://example.com/new-image.jpg');
    });
  });

  describe('delete', () => {
    it('deletes user successfully when not last manager', async () => {
      workspaceUserService.findAllByUserId.mockResolvedValue([
        {
          ...mockWorkspaceUser,
          workspaceRole: WorkspaceUserRole.MEMBER,
        } as any,
      ]);
      userRepository.delete.mockResolvedValue(true);

      await service.delete('user-1');

      expect(workspaceUserService.findAllByUserId).toHaveBeenCalledWith(
        'user-1',
      );
      expect(userRepository.delete).toHaveBeenCalledWith('user-1');
    });

    it('throws SOLE_MANAGER_CONFLICT if user is last manager in workspace', async () => {
      workspaceUserService.findAllByUserId.mockResolvedValue([
        mockWorkspaceUser as any,
      ]);

      try {
        await service.delete('user-1');
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.CONFLICT,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.SOLE_MANAGER_CONFLICT,
        });
      }

      expect(userRepository.delete).not.toHaveBeenCalled();
    });

    it('throws SOLE_MANAGER_CONFLICT if user is manager in multiple workspaces', async () => {
      const secondWorkspace = {
        ...mockWorkspaceUser,
        workspace: { ...mockWorkspaceUser.workspace, id: 'workspace-2' },
      };
      workspaceUserService.findAllByUserId.mockResolvedValue([
        mockWorkspaceUser as any,
        secondWorkspace as any,
      ]);

      try {
        await service.delete('user-1');
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.CONFLICT,
        );
      }

      expect(userRepository.delete).not.toHaveBeenCalled();
    });

    it('throws INVALID_PAYLOAD if user deletion fails', async () => {
      workspaceUserService.findAllByUserId.mockResolvedValue([]);
      userRepository.delete.mockResolvedValue(false);

      try {
        await service.delete('user-1');
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.NOT_FOUND,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.INVALID_PAYLOAD,
        });
      }
    });

    it('allows delete if user is member in workspaces', async () => {
      const memberWorkspace = {
        ...mockWorkspaceUser,
        workspaceRole: WorkspaceUserRole.MEMBER,
      };
      workspaceUserService.findAllByUserId.mockResolvedValue([
        memberWorkspace as any,
      ]);
      userRepository.delete.mockResolvedValue(true);

      await service.delete('user-1');

      expect(userRepository.delete).toHaveBeenCalledWith('user-1');
    });

    it('allows delete if user has no workspaces', async () => {
      workspaceUserService.findAllByUserId.mockResolvedValue([]);
      userRepository.delete.mockResolvedValue(true);

      await service.delete('user-1');

      expect(userRepository.delete).toHaveBeenCalledWith('user-1');
    });
  });
});
