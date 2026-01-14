import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { Test, TestingModule } from '@nestjs/testing';
import { DateTime } from 'luxon';
import { AggregatedConfig } from 'src/config/config.type';
import { SessionCore } from 'src/modules/session/domain/session-core.domain';
import { Session } from 'src/modules/session/domain/session.domain';
import { SessionService } from 'src/modules/session/session.service';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { UserStatus } from 'src/modules/user/domain/user-status.enum';
import { User } from 'src/modules/user/domain/user.domain';
import { UserService } from 'src/modules/user/user.service';
import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserWithWorkspaceCore } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-with-workspace.domain';
import { WorkspaceUserService } from 'src/modules/workspace/workspace-user-module/workspace-user.service';
import { AuthService } from './auth.service';
import { AuthProvider } from './domain/auth-provider.enum';
import { SocialLogin } from './domain/social-login.domain';
import { JwtPayload } from './strategies/jwt-payload.type';

describe('AuthService', () => {
  let service: AuthService;
  let jwtService: jest.Mocked<JwtService>;
  let userService: jest.Mocked<UserService>;
  let workspaceUserService: jest.Mocked<WorkspaceUserService>;
  let configService: jest.Mocked<ConfigService<AggregatedConfig>>;
  let sessionService: jest.Mocked<SessionService>;
  let unitOfWorkService: jest.Mocked<UnitOfWorkService>;

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

  const mockSessionCore: SessionCore = {
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
  };

  const mockSession: Session = {
    id: 'session-1',
    user: mockUser,
    hash: 'session-hash-123',
    ipAddress: '192.168.1.1',
    deviceModel: 'iPhone 15',
    osVersion: 'iOS 17.0',
    appVersion: '1.0.0',
    accessTokenVersion: 1,
    createdAt: new Date('2024-01-01'),
    updatedAt: new Date('2024-01-01'),
    deletedAt: null,
  };

  const mockWorkspaceUser: WorkspaceUserWithWorkspaceCore = {
    id: 'workspace-user-1',
    workspaceRole: WorkspaceUserRole.MANAGER,
    workspace: {
      id: 'workspace-1',
      name: 'Test Workspace',
      description: null,
      pictureUrl: null,
      createdAt: new Date('2024-01-01'),
      updatedAt: new Date('2024-01-01'),
      deletedAt: null,
    },
    createdAt: new Date('2024-01-01'),
    updatedAt: new Date('2024-01-01'),
    deletedAt: null,
  };

  const mockSocialLogin: SocialLogin = {
    id: 'social-123',
    email: 'test@example.com',
    firstName: 'John',
    lastName: 'Doe',
    profileImageUrl: 'https://example.com/image.jpg',
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: JwtService,
          useValue: {
            signAsync: jest.fn(),
          },
        },
        {
          provide: UserService,
          useValue: {
            findBySocialIdAndProvider: jest.fn(),
            findById: jest.fn(),
            create: jest.fn(),
            update: jest.fn(),
          },
        },
        {
          provide: WorkspaceUserService,
          useValue: {
            findAllByUserIdWithWorkspace: jest.fn(),
          },
        },
        {
          provide: ConfigService<AggregatedConfig>,
          useValue: {
            getOrThrow: jest.fn(),
          },
        },
        {
          provide: SessionService,
          useValue: {
            create: jest.fn(),
            findByIdWithUser: jest.fn(),
            update: jest.fn(),
            deleteById: jest.fn(),
          },
        },
        {
          provide: UnitOfWorkService,
          useValue: {
            withTransaction: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    jwtService = module.get(JwtService) as jest.Mocked<JwtService>;
    userService = module.get(UserService) as jest.Mocked<UserService>;
    workspaceUserService = module.get(
      WorkspaceUserService,
    ) as jest.Mocked<WorkspaceUserService>;
    configService = module.get(ConfigService) as jest.Mocked<
      ConfigService<AggregatedConfig>
    >;
    sessionService = module.get(SessionService) as jest.Mocked<SessionService>;
    unitOfWorkService = module.get(
      UnitOfWorkService,
    ) as jest.Mocked<UnitOfWorkService>;
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('socialLogin', () => {
    it('should create a new user and session when user does not exist', async () => {
      const socialData = mockSocialLogin;

      userService.findBySocialIdAndProvider.mockResolvedValue(null);
      userService.create.mockResolvedValue(mockUser);
      sessionService.create.mockResolvedValue(mockSessionCore);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([]);
      configService.getOrThrow
        .mockReturnValueOnce('1h')
        .mockReturnValueOnce('secret-key')
        .mockReturnValueOnce('7d')
        .mockReturnValueOnce('refresh-secret-key');
      jwtService.signAsync
        .mockResolvedValueOnce('access-token')
        .mockResolvedValueOnce('refresh-token');
      unitOfWorkService.withTransaction.mockImplementation(
        async (cb) => await cb(),
      );

      const result = await service.socialLogin({
        authProvider: AuthProvider.GOOGLE,
        socialData,
        ipAddress: '192.168.1.1',
        deviceModel: 'iPhone 15',
        osVersion: 'iOS 17.0',
        appVersion: '1.0.0',
      });

      expect(userService.findBySocialIdAndProvider).toHaveBeenCalledWith({
        socialId: socialData.id,
        provider: AuthProvider.GOOGLE,
      });
      expect(userService.create).toHaveBeenCalledWith({
        email: socialData.email,
        firstName: socialData.firstName,
        lastName: socialData.lastName,
        socialId: socialData.id,
        provider: AuthProvider.GOOGLE,
        profileImageUrl: socialData.profileImageUrl,
        status: UserStatus.ACTIVE,
      });
      expect(sessionService.create).toHaveBeenCalled();
      expect(jwtService.signAsync).toHaveBeenCalledWith(
        expect.objectContaining({ sub: mockUser.id }),
        expect.objectContaining({ secret: 'secret-key' }),
      );
      expect(result).toEqual({
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
        tokenExpires: expect.any(Number),
        user: {
          id: mockUser.id,
          email: mockUser.email,
          firstName: mockUser.firstName,
          lastName: mockUser.lastName,
          roles: [],
          profileImageUrl: mockUser.profileImageUrl,
          createdAt: DateTime.fromJSDate(mockUser.createdAt).toISO(),
        },
      });
    });

    it('should update existing user if email changed and return session', async () => {
      const updatedSocialData: SocialLogin = {
        ...mockSocialLogin,
        email: 'newemail@example.com',
      };
      const updatedUser = { ...mockUser, email: 'newemail@example.com' };

      userService.findBySocialIdAndProvider.mockResolvedValue(mockUser);
      userService.update.mockResolvedValue(updatedUser);
      sessionService.create.mockResolvedValue(mockSessionCore);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        mockWorkspaceUser,
      ]);
      configService.getOrThrow
        .mockReturnValueOnce('1h')
        .mockReturnValueOnce('secret-key')
        .mockReturnValueOnce('7d')
        .mockReturnValueOnce('refresh-secret-key');
      jwtService.signAsync
        .mockResolvedValueOnce('access-token')
        .mockResolvedValueOnce('refresh-token');
      unitOfWorkService.withTransaction.mockImplementation(
        async (cb) => await cb(),
      );

      const result = await service.socialLogin({
        authProvider: AuthProvider.GOOGLE,
        socialData: updatedSocialData,
        ipAddress: '192.168.1.1',
        deviceModel: 'iPhone 15',
        osVersion: 'iOS 17.0',
        appVersion: '1.0.0',
      });

      expect(userService.update).toHaveBeenCalledWith({
        id: mockUser.id,
        data: {
          email: updatedSocialData.email,
          firstName: undefined,
          lastName: undefined,
          profileImageUrl: undefined,
        },
      });
      expect(result.user.roles).toEqual([
        {
          workspaceId: mockWorkspaceUser.workspace.id,
          role: mockWorkspaceUser.workspaceRole,
        },
      ]);
    });

    it('should handle user with existing workspace roles', async () => {
      userService.findBySocialIdAndProvider.mockResolvedValue(mockUser);
      sessionService.create.mockResolvedValue(mockSessionCore);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        mockWorkspaceUser,
      ]);
      configService.getOrThrow
        .mockReturnValueOnce('1h')
        .mockReturnValueOnce('secret-key')
        .mockReturnValueOnce('7d')
        .mockReturnValueOnce('refresh-secret-key');
      jwtService.signAsync
        .mockResolvedValueOnce('access-token')
        .mockResolvedValueOnce('refresh-token');
      unitOfWorkService.withTransaction.mockImplementation(
        async (cb) => await cb(),
      );

      const result = await service.socialLogin({
        authProvider: AuthProvider.GOOGLE,
        socialData: mockSocialLogin,
        ipAddress: '192.168.1.1',
        deviceModel: 'iPhone 15',
        osVersion: 'iOS 17.0',
        appVersion: '1.0.0',
      });

      expect(result.user.roles).toHaveLength(1);
      expect(result.user.roles[0]).toEqual({
        workspaceId: mockWorkspaceUser.workspace.id,
        role: mockWorkspaceUser.workspaceRole,
      });
    });
  });

  describe('refreshToken', () => {
    it('should successfully refresh tokens with valid data', async () => {
      const jwtRefreshPayload = {
        sessionId: 'session-1',
        hash: 'session-hash-123',
      };

      sessionService.findByIdWithUser.mockResolvedValue(mockSession);
      userService.findById.mockResolvedValue(mockUser);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        mockWorkspaceUser,
      ]);
      sessionService.update.mockResolvedValue(mockSessionCore);
      configService.getOrThrow
        .mockReturnValueOnce('1h')
        .mockReturnValueOnce('secret-key')
        .mockReturnValueOnce('7d')
        .mockReturnValueOnce('refresh-secret-key');
      jwtService.signAsync
        .mockResolvedValueOnce('new-access-token')
        .mockResolvedValueOnce('new-refresh-token');

      const result = await service.refreshToken(jwtRefreshPayload);

      expect(sessionService.findByIdWithUser).toHaveBeenCalledWith(
        jwtRefreshPayload.sessionId,
      );
      expect(userService.findById).toHaveBeenCalledWith(mockUser.id);
      expect(sessionService.update).toHaveBeenCalledWith({
        id: mockSession.id,
        data: { hash: expect.any(String) },
      });
      expect(jwtService.signAsync).toHaveBeenCalledTimes(2);
      expect(result).toEqual({
        accessToken: 'new-access-token',
        refreshToken: 'new-refresh-token',
        tokenExpires: expect.any(Number),
      });
    });

    it('should generate new hash when refreshing token', async () => {
      const jwtRefreshPayload = {
        sessionId: 'session-1',
        hash: 'session-hash-123',
      };

      sessionService.findByIdWithUser.mockResolvedValue(mockSession);
      userService.findById.mockResolvedValue(mockUser);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([]);
      sessionService.update.mockResolvedValue(mockSessionCore);
      configService.getOrThrow
        .mockReturnValueOnce('1h')
        .mockReturnValueOnce('secret-key')
        .mockReturnValueOnce('7d')
        .mockReturnValueOnce('refresh-secret-key');
      jwtService.signAsync
        .mockResolvedValueOnce('new-access-token')
        .mockResolvedValueOnce('new-refresh-token');

      await service.refreshToken(jwtRefreshPayload);

      expect(sessionService.update).toHaveBeenCalledWith({
        id: mockSession.id,
        data: {
          hash: expect.any(String),
        },
      });

      // Verify that the new hash is different from the old one
      const updateCall = sessionService.update.mock.calls[0][0];
      expect(updateCall.data.hash).not.toBe(mockSession.hash);
    });

    it('should refresh with multiple workspace roles', async () => {
      const multipleWorkspaceUsers: WorkspaceUserWithWorkspaceCore[] = [
        mockWorkspaceUser,
        {
          ...mockWorkspaceUser,
          id: 'workspace-user-2',
          workspace: {
            id: 'workspace-2',
            name: 'Another Workspace',
            description: null,
            pictureUrl: null,
            createdAt: new Date('2024-01-01'),
            updatedAt: new Date('2024-01-01'),
            deletedAt: null,
          },
        },
      ];

      const jwtRefreshPayload = {
        sessionId: 'session-1',
        hash: 'session-hash-123',
      };

      sessionService.findByIdWithUser.mockResolvedValue(mockSession);
      userService.findById.mockResolvedValue(mockUser);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue(
        multipleWorkspaceUsers,
      );
      sessionService.update.mockResolvedValue(mockSessionCore);
      configService.getOrThrow
        .mockReturnValueOnce('1h')
        .mockReturnValueOnce('secret-key')
        .mockReturnValueOnce('7d')
        .mockReturnValueOnce('refresh-secret-key');
      jwtService.signAsync
        .mockResolvedValueOnce('new-access-token')
        .mockResolvedValueOnce('new-refresh-token');

      const result = await service.refreshToken(jwtRefreshPayload);

      expect(jwtService.signAsync).toHaveBeenCalledWith(
        expect.objectContaining({
          roles: expect.arrayContaining([
            expect.objectContaining({ workspaceId: 'workspace-1' }),
            expect.objectContaining({ workspaceId: 'workspace-2' }),
          ]),
        }),
        expect.any(Object),
      );
    });
  });

  describe('logout', () => {
    it('should delete session by id', async () => {
      const jwtPayload: JwtPayload = {
        sub: 'user-1',
        roles: [
          {
            workspaceId: 'workspace-1',
            role: WorkspaceUserRole.MANAGER,
          },
        ],
        sessionId: 'session-1',
        atv: 1,
      };

      sessionService.deleteById.mockResolvedValue(undefined);

      await service.logout(jwtPayload);

      expect(sessionService.deleteById).toHaveBeenCalledWith(
        jwtPayload.sessionId,
      );
    });

    it('should return a promise', async () => {
      const jwtPayload: JwtPayload = {
        sub: 'user-1',
        roles: [],
        sessionId: 'session-1',
        atv: 1,
      };

      sessionService.deleteById.mockResolvedValue(undefined);

      const result = service.logout(jwtPayload);

      expect(result).toBeInstanceOf(Promise);
    });
  });
});
