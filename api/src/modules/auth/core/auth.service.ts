import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { AggregatedConfig } from 'src/config/config.model';
import ms from 'ms';
import * as crypto from 'crypto';
import { JwtPayload } from './strategies/models/jwt-payload.model';
import { plainToInstance } from 'class-transformer';
import { RegisterRequest } from './dto/register-request.dto';
import { SocialLoginDomain } from './domain/social-response.domain';
import { LoginResponse } from './dto/login-response.dto';
import { Nullable } from 'src/common/types/nullable.type';
import { UserDomain } from 'src/modules/user/domain/user.domain';
import { UserService } from 'src/modules/user/user.service';
import { AuthProvider } from './domain/auth-provider.enum';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { UserStatus } from 'src/modules/user/user-status.enum';
import { WorkspaceUserDomain } from 'src/modules/workspace/domain/workspace-user.domain';
import { WorkspaceService } from 'src/modules/workspace/workspace-user.service';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly userService: UserService,
    private readonly workspaceService: WorkspaceService,
    private readonly configService: ConfigService<AggregatedConfig>,
  ) {}

  async register(registerDto: RegisterRequest): Promise<LoginResponseDto> {
    const createdUser = await this.userService.create({
      ...registerDto,
      role: {
        name: RoleEnum.user,
      },
      status: {
        name: StatusEnum.active,
      },
    });
    const { token, refreshToken, tokenExpires } = await this.getTokensData({
      uid: createdUser.uid,
      role: null, // new users don't have roles, since they are not yet in any workspace
    });

    return {
      token,
      refreshToken,
      tokenExpires,
      user: plainToInstance(UserDto, createdUser),
    };
  }

  async socialLogin(
    authProvider: AuthProvider,
    socialData: SocialLoginDomain,
  ): Promise<LoginResponse> {
    let user: Nullable<UserDomain> =
      await this.userService.findBySocialIdAndProvider({
        socialId: socialData.id,
        provider: authProvider,
      });

    if (user) {
      // User has already "registered" via a social auth provider so
      // we check if there are any properties retrieved by the auth service
      // that have changed
      let email = undefined;
      let firstName = undefined;
      let lastName = undefined;
      let profileImageUrl = undefined;

      if (user.email !== socialData.email) {
        email = socialData.email;
      }

      if (user.firstName !== socialData.firstName) {
        firstName = socialData.firstName;
      }

      if (user.lastName !== socialData.lastName) {
        lastName = socialData.lastName;
      }

      if (user.lastName !== socialData.lastName) {
        profileImageUrl = socialData.profileImageUrl;
      }

      user = await this.userService.updateSelf(user.id, {
        email,
        firstName,
        lastName,
        profileImageUrl,
      });
    } else {
      // User hasn't yet "registered"
      user = await this.userService.create({
        email: socialData.email,
        firstName: socialData.firstName,
        lastName: socialData.lastName,
        socialId: socialData.id,
        provider: authProvider,
        status: UserStatus.ACTIVE, // since it's auth register, we activate the user immediately
      });
    }

    const hash = crypto
      .createHash('sha256')
      .update(crypto.randomBytes(length).toString('hex'))
      .digest('hex');

    const session = await this.sessionService.create({
      user,
      hash,
    });

    const roles = await this.workspaceService.getWorkspaceUserRoles(user.id);

    const {
      token: jwtToken,
      refreshToken,
      tokenExpires,
    } = await this.getTokensData({
      id: user.id,
      roles,
      sessionId: session.id,
      hash,
    });

    return {
      refreshToken,
      token: jwtToken,
      tokenExpires,
      user,
    };
  }

  async me(userJwtPayload: JwtPayload): Promise<UserDto> {
    const user = this.userService.findOne({
      where: {
        uid: userJwtPayload.sub,
      },
    });

    return plainToInstance(UserDto, user);
  }

  async refreshToken(
    data: Omit<JwtPayload, 'role'>,
  ): Promise<Omit<LoginResponseDto, 'user'>> {
    const user = await this.userService.findOne({
      where: {
        uid: data.sub,
      },
    });

    const { token, refreshToken, tokenExpires } = await this.getTokensData({
      uid: user!.uid,
      role: user!.role,
    });

    return {
      token,
      refreshToken,
      tokenExpires,
    };
  }

  private async getTokensData(data: {
    id: UserDomain['id'];
    roles: {
      workspaceId: string;
      role: WorkspaceUserDomain['role'];
    }[];
    sessionId: Session['id'];
    hash: Session['hash'];
  }) {
    const tokenExpiresIn = this.configService.getOrThrow('auth.expires', {
      infer: true,
    });

    const tokenExpires = Date.now() + ms(tokenExpiresIn);

    const [token, refreshToken] = await Promise.all([
      await this.jwtService.signAsync(
        {
          id: data.id,
          roles: data.roles,
          sessionId: data.sessionId,
        },
        {
          secret: this.configService.getOrThrow('auth.secret', { infer: true }),
          expiresIn: tokenExpiresIn,
        },
      ),
      await this.jwtService.signAsync(
        {
          sessionId: data.sessionId,
          hash: data.hash,
        },
        {
          secret: this.configService.getOrThrow('auth.refreshSecret', {
            infer: true,
          }),
          expiresIn: this.configService.getOrThrow('auth.refreshExpires', {
            infer: true,
          }),
        },
      ),
    ]);

    return {
      token,
      refreshToken,
      tokenExpires,
    };
  }
}
