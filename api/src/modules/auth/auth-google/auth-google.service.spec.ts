import { UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test, TestingModule } from '@nestjs/testing';
import { OAuth2Client, TokenPayload } from 'google-auth-library';
import { AggregatedConfig } from 'src/config/config.type';
import { AuthGoogleService } from './auth-google.service';

// Mocks the import - meaning import from and this argument
// need to be the same
jest.mock('google-auth-library');

describe('AuthGoogleService', () => {
  let service: AuthGoogleService;
  let configService: jest.Mocked<ConfigService<AggregatedConfig>>;
  let mockOAuthClientInstance: any;

  const mockTokenPayload: Partial<TokenPayload> = {
    sub: 'google-123',
    email: 'test@example.com',
    given_name: 'John',
    family_name: 'Doe',
    picture: 'https://example.com/pic.jpg',
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    mockOAuthClientInstance = {
      verifyIdToken: jest.fn(),
    };

    (OAuth2Client as unknown as jest.Mock).mockImplementation(
      () => mockOAuthClientInstance,
    );

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthGoogleService,
        {
          provide: ConfigService<AggregatedConfig>,
          useValue: {
            getOrThrow: jest.fn((key) => {
              if (key === 'google.auth.clientId') {
                return 'mock-client-id';
              }
              if (key === 'google.auth.clientSecret') {
                return 'mock-client-secret';
              }
              return null;
            }),
          },
        },
      ],
    }).compile();

    service = module.get<AuthGoogleService>(AuthGoogleService);
    configService = module.get(ConfigService) as jest.Mocked<
      ConfigService<AggregatedConfig>
    >;
  });

  describe('socialLogin', () => {
    it('returns user data for valid idToken', async () => {
      mockOAuthClientInstance.verifyIdToken.mockResolvedValue({
        getPayload: () => mockTokenPayload,
      });

      const result = await service.getProfileByToken({
        idToken: 'valid-id-token',
      });

      expect(mockOAuthClientInstance.verifyIdToken).toHaveBeenCalledWith({
        idToken: 'valid-id-token',
        audience: 'mock-client-id',
      });
      expect(result).toEqual({
        id: 'google-123',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        profileImageUrl: 'https://example.com/pic.jpg',
      });
    });

    it('throws Unauthorized exception if token payload is null', async () => {
      mockOAuthClientInstance.verifyIdToken.mockResolvedValue({
        getPayload: () => null,
      });

      // We don't use result constant here because we expect an exception
      expect(service.getProfileByToken({ idToken: 'token' })).rejects.toThrow(
        UnauthorizedException,
      );
      expect(mockOAuthClientInstance.verifyIdToken).toHaveBeenCalledWith({
        idToken: 'token',
        audience: 'mock-client-id',
      });
    });
  });
});
