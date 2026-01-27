import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { Test, TestingModule } from '@nestjs/testing';
import { DateTime } from 'luxon';
import { ClsService } from 'nestjs-cls';
import { CLS_CONTEXT_APP_METADATA_KEY } from 'src/common/helper/constants';
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

const mockSessionCoreFactory = (
  overrides?: Partial<SessionCore>,
): SessionCore => ({
  id: 'session-1',
  hash: 'session-hash-123',
  ipAddress: '192.168.1.1',
  deviceModel: 'iPhone 15',
  osVersion: 'iOS 17.0',
  appVersion: '1.0.0',
  buildNumber: '1',
  accessTokenVersion: 1,
  createdAt: new Date(),
  updatedAt: new Date(),
  deletedAt: null,
  ...overrides,
});

const mockSessionFactory = (overrides?: Partial<Session>): Session =>
  ({
    ...mockSessionCoreFactory(),
    user: mockUserFactory(),
    ...overrides,
  }) as Session;

const mockWorkspaceUserFactory = (
  overrides?: Partial<WorkspaceUserWithWorkspaceCore>,
): WorkspaceUserWithWorkspaceCore => ({
  id: 'workspace-user-1',
  workspaceRole: WorkspaceUserRole.MANAGER,
  workspace: {
    id: 'workspace-1',
    name: 'Test Workspace',
    description: null,
    pictureUrl: null,
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
  },
  createdAt: new Date(),
  updatedAt: new Date(),
  deletedAt: null,
  ...overrides,
});

const mockSocialLoginFactory = (
  overrides?: Partial<SocialLogin>,
): SocialLogin => ({
  id: 'social-123',
  email: 'test@example.com',
  firstName: 'John',
  lastName: 'Doe',
  profileImageUrl: 'https://example.com/image.jpg',
  ...overrides,
});

const createMockJwtService = () => ({
  signAsync: jest.fn(),
});

const createMockUserService = () => ({
  findBySocialIdAndProvider: jest.fn(),
  findById: jest.fn(),
  create: jest.fn(),
  update: jest.fn(),
});

const createMockWorkspaceUserService = () => ({
  findAllByUserIdWithWorkspace: jest.fn(),
});

const createMockConfigService = () => ({
  getOrThrow: jest.fn((key: string) => {
    switch (key) {
      case 'auth.expires':
        return '1h';
      case 'auth.secret':
        return 'secret';
      case 'auth.refreshSecret':
        return 'refresh-secret';
      case 'auth.refreshExpires':
        return '7d';
      default:
        return null;
    }
  }),
});

const createMockSessionService = () => ({
  create: jest.fn(),
  findByIdWithUser: jest.fn(),
  update: jest.fn(),
  delete: jest.fn(),
});

const createMockUnitOfWorkService = () => ({
  withTransaction: jest.fn().mockImplementation(async (cb) => {
    await Promise.resolve();
    return cb();
  }),
});

const createMockClsService = () => ({
  get: jest.fn(),
  set: jest.fn(),
});

describe('AuthService', () => {
  let service: AuthService;
  let jwtService: ReturnType<typeof createMockJwtService>;
  let userService: ReturnType<typeof createMockUserService>;
  let workspaceUserService: ReturnType<typeof createMockWorkspaceUserService>;
  let sessionService: ReturnType<typeof createMockSessionService>;
  let clsService: ReturnType<typeof createMockClsService>;

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: JwtService,
          useValue: createMockJwtService(),
        },
        {
          provide: UserService,
          useValue: createMockUserService(),
        },
        {
          provide: WorkspaceUserService,
          useValue: createMockWorkspaceUserService(),
        },
        {
          provide: ConfigService,
          useValue: createMockConfigService(),
        },
        {
          provide: SessionService,
          useValue: createMockSessionService(),
        },
        {
          provide: UnitOfWorkService,
          useValue: createMockUnitOfWorkService(),
        },
        {
          provide: ClsService,
          useValue: createMockClsService(),
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    jwtService = module.get(JwtService) as any;
    userService = module.get(UserService) as any;
    workspaceUserService = module.get(WorkspaceUserService) as any;
    sessionService = module.get(SessionService) as any;
    clsService = module.get(ClsService) as any;
  });

  describe('socialLogin', () => {
    const appMetadata = {
      deviceModel: 'iPhone 15',
      osVersion: 'iOS 17.0',
      appVersion: '1.0.0',
      buildNumber: '1',
    };

    it('should create a new user and session when user does not exist', async () => {
      // ARRANGE
      const socialData = mockSocialLoginFactory();
      const createdUser = mockUserFactory();
      const createdSession = mockSessionCoreFactory();

      userService.findBySocialIdAndProvider.mockResolvedValue(null);
      userService.create.mockResolvedValue(createdUser);
      sessionService.create.mockResolvedValue(createdSession);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([]);
      clsService.get.mockImplementation((key) => {
        if (key === CLS_CONTEXT_APP_METADATA_KEY) {
          return appMetadata;
        }
        return null;
      });
      jwtService.signAsync
        .mockResolvedValueOnce('access-token')
        .mockResolvedValueOnce('refresh-token');

      // ACT
      const result = await service.socialLogin({
        authProvider: AuthProvider.GOOGLE,
        socialData,
        ipAddress: '192.168.1.1',
      });

      // ASSERT
      expect(userService.create).toHaveBeenCalledWith({
        email: socialData.email,
        firstName: socialData.firstName,
        lastName: socialData.lastName,
        socialId: socialData.id,
        provider: AuthProvider.GOOGLE,
        profileImageUrl: socialData.profileImageUrl,
        status: UserStatus.ACTIVE,
      });
      expect(sessionService.create).toHaveBeenCalledWith({
        userId: createdUser.id,
        hash: expect.any(String),
        ...appMetadata,
        ipAddress: '192.168.1.1',
      });
      expect(result).toEqual({
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
        tokenExpires: expect.any(Number),
        user: {
          id: createdUser.id,
          email: createdUser.email,
          firstName: createdUser.firstName,
          lastName: createdUser.lastName,
          roles: [],
          profileImageUrl: createdUser.profileImageUrl,
          createdAt: DateTime.fromJSDate(createdUser.createdAt).toISO(),
        },
      });
    });

    it('should update existing user if profile data changed', async () => {
      const existingUser = mockUserFactory({
        email: 'old@example.com',
      });
      const socialData = mockSocialLoginFactory({
        email: 'new@example.com',
      });
      const updatedUser = mockUserFactory({
        email: 'new@example.com',
      });
      const session = mockSessionCoreFactory();
      userService.findBySocialIdAndProvider.mockResolvedValue(existingUser);
      userService.update.mockResolvedValue(updatedUser);
      sessionService.create.mockResolvedValue(session);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([]);
      clsService.get.mockImplementation((key) => {
        if (key === CLS_CONTEXT_APP_METADATA_KEY) {
          return appMetadata;
        }
        return null;
      });
      jwtService.signAsync.mockResolvedValue('token');

      await service.socialLogin({
        authProvider: AuthProvider.GOOGLE,
        socialData,
        ...appMetadata,
        ipAddress: '192.168.1.1.',
      });

      expect(userService.update).toHaveBeenCalledWith({
        id: existingUser.id,
        data: expect.objectContaining({
          email: 'new@example.com',
        }),
      });
    });

    it('should NOT update user if data matches', async () => {
      const socialData = mockSocialLoginFactory();
      const existingUser = mockUserFactory({
        email: socialData.email,
        firstName: socialData.firstName,
        lastName: socialData.lastName,
        profileImageUrl: socialData.profileImageUrl,
      });
      userService.findBySocialIdAndProvider.mockResolvedValue(existingUser);
      sessionService.create.mockResolvedValue(mockSessionCoreFactory());
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([]);
      clsService.get.mockImplementation((key) => {
        if (key === CLS_CONTEXT_APP_METADATA_KEY) {
          return appMetadata;
        }
        return null;
      });
      jwtService.signAsync.mockResolvedValue('token');

      await service.socialLogin({
        authProvider: AuthProvider.GOOGLE,
        socialData,
        ...appMetadata,
        ipAddress: '192.168.1.1',
      });

      expect(userService.update).not.toHaveBeenCalled();
    });

    it('should return user with workspace roles', async () => {
      const user = mockUserFactory();
      const workspaceUser = mockWorkspaceUserFactory();
      userService.findBySocialIdAndProvider.mockResolvedValue(user);
      sessionService.create.mockResolvedValue(mockSessionCoreFactory());
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        workspaceUser,
      ]);
      clsService.get.mockImplementation((key) => {
        if (key === CLS_CONTEXT_APP_METADATA_KEY) {
          return appMetadata;
        }
        return null;
      });
      jwtService.signAsync.mockResolvedValue('token');

      const result = await service.socialLogin({
        authProvider: AuthProvider.GOOGLE,
        socialData: mockSocialLoginFactory(),
        ...appMetadata,
        ipAddress: '192.168.1.1',
      });

      expect(result.user.roles).toHaveLength(1);
      expect(result.user.roles[0]).toEqual({
        workspaceId: workspaceUser.workspace.id,
        role: workspaceUser.workspaceRole,
      });
      // Verify roles are baked into the JWT
      expect(jwtService.signAsync).toHaveBeenCalledWith(
        expect.objectContaining({
          roles: expect.arrayContaining([
            {
              workspaceId: workspaceUser.workspace.id,
              role: workspaceUser.workspaceRole,
            },
          ]),
        }),
        expect.any(Object),
      );
    });
  });

  describe('refreshToken', () => {
    it('should successfully refresh tokens and rotate hash', async () => {
      const session = mockSessionFactory();
      const user = mockUserFactory({ id: session.user.id });
      const workspaceUser = mockWorkspaceUserFactory();
      sessionService.findByIdWithUser.mockResolvedValue(session);
      userService.findById.mockResolvedValue(user);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        workspaceUser,
      ]);
      sessionService.update.mockResolvedValue(mockSessionCoreFactory());
      jwtService.signAsync
        .mockResolvedValueOnce('new-access')
        .mockResolvedValueOnce('new-refresh');

      const payload = {
        sessionId: session.id,
        hash: 'old-hash',
      };

      const result = await service.refreshToken(payload);

      expect(sessionService.update).toHaveBeenCalledWith({
        id: session.id,
        data: {
          hash: expect.any(String),
        },
      });
      // Ensure hash rotation
      const updateCall = sessionService.update.mock.calls[0][0];
      expect(updateCall.data.hash).not.toBe(session.hash);
      expect(result).toEqual({
        accessToken: 'new-access',
        refreshToken: 'new-refresh',
        tokenExpires: expect.any(Number),
      });
    });

    it('should sign tokens with updated roles', async () => {
      const session = mockSessionFactory();
      const user = mockUserFactory();
      const wsUser1 = mockWorkspaceUserFactory({
        workspace: { id: 'w1' } as any,
      });
      const wsUser2 = mockWorkspaceUserFactory({
        workspace: { id: 'w2' } as any,
      });
      sessionService.findByIdWithUser.mockResolvedValue(session);
      userService.findById.mockResolvedValue(user);
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        wsUser1,
        wsUser2,
      ]);
      sessionService.update.mockResolvedValue(mockSessionCoreFactory());
      jwtService.signAsync.mockResolvedValue('token');

      await service.refreshToken({ sessionId: 's1', hash: 'h1' });

      expect(jwtService.signAsync).toHaveBeenCalledWith(
        expect.objectContaining({
          roles: expect.arrayContaining([
            { workspaceId: 'w1', role: expect.any(String) },
            { workspaceId: 'w2', role: expect.any(String) },
          ]),
        }),
        expect.any(Object),
      );
    });
  });

  describe('logout', () => {
    it('should delete session by id', async () => {
      const payload: JwtPayload = {
        sub: 'user-1',
        roles: [],
        sessionId: 'session-1',
        atv: 1,
      };
      sessionService.delete.mockResolvedValue(undefined);

      await service.logout(payload);

      expect(sessionService.delete).toHaveBeenCalledWith(payload.sessionId);
    });
  });
});
