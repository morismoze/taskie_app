import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { AggregatedConfig } from 'src/config/config.model';
import ms from 'ms';
import * as crypto from 'crypto';
import { JwtPayload } from './strategies/domain/jwt-payload.domain';
import { SocialLoginDomain } from './domain/social-response.domain';
import { LoginResponse } from './dto/login-response.dto';
import { Nullable } from 'src/common/types/nullable.type';
import { UserDomain } from 'src/modules/user/domain/user.domain';
import { UserService } from 'src/modules/user/user.service';
import { AuthProvider } from './domain/auth-provider.enum';
import { UserStatus } from 'src/modules/user/user-status.enum';
import { WorkspaceUserService } from 'src/modules/workspace/workspace-user-module/workspace-user.service';
import { WorkspaceUserDomain } from 'src/modules/workspace/workspace-user-module/domain/workspace-user.domain';
import { WorkspaceUserMembershipDto } from 'src/modules/workspace/workspace-user-module/dto/workspace-user.dto';
import { UserDto } from 'src/modules/user/dto/user.dto';
import { SessionService } from 'src/modules/session/session.service';
import { SessionDomain } from 'src/modules/session/domain/session.domain';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly userService: UserService,
    private readonly workspaceUserService: WorkspaceUserService,
    private readonly configService: ConfigService<AggregatedConfig>,
    private readonly sessionService: SessionService,
  ) {}

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

    const session = await this.sessionService.create(user, hash);

    const workspaceUserMemberships =
      await this.workspaceUserService.getWorkspaceUserMemberships(user.id);

    const { accessToken, refreshToken, tokenExpires } =
      await this.getTokensData(
        {
          userId: user.id,
          roles: workspaceUserMemberships.map((wu) => ({
            workspaceId: wu.workspaceId,
            role: wu.role,
          })),
          sessionId: session.id,
        },
        hash,
      );

    const workspaceUserMembershipsDto: WorkspaceUserMembershipDto[] =
      workspaceUserMemberships.map((wu) => ({
        createdAt: wu.createdAt,
        id: wu.id,
        isOwner: wu.isOwner,
        role: wu.role,
        workspaceId: wu.workspaceId,
      }));

    const userDto: UserDto = {
      createdAt: user.createdAt,
      email: user.email,
      firstName: user.firstName,
      id: user.id,
      lastName: user.lastName,
      memberships: workspaceUserMembershipsDto,
      profileImageUrl: user.profileImageUrl,
    };

    return {
      refreshToken,
      accessToken,
      tokenExpires,
      user: userDto,
    };
  }

  async refreshToken(
    data: Omit<JwtPayload, 'role'>,
  ): Promise<Omit<LoginResponse, 'user'>> {
    const user = await this.userService.findOne({
      where: {
        uid: data.sub,
      },
    });

    const workspaceUserMemberships =
      await this.workspaceUserService.getWorkspaceUserMemberships(user.id);

    const { accessToken, refreshToken, tokenExpires } =
      await this.getTokensData(
        {
          userId: user.id,
          roles: workspaceUserMemberships.map((wu) => ({
            workspaceId: wu.workspaceId,
            role: wu.role,
          })),
          sessionId: session.id,
        },
        hash,
      );

    return {
      accessToken,
      refreshToken,
      tokenExpires,
    };
  }

  private async getTokensData(
    data: Omit<JwtPayload, 'iat' | 'exp'>,
    hash: SessionDomain['hash'],
  ) {
    const tokenExpiresIn = this.configService.getOrThrow('auth.expires', {
      infer: true,
    });

    const tokenExpires = Date.now() + ms(tokenExpiresIn);

    const [accessToken, refreshToken] = await Promise.all([
      await this.jwtService.signAsync(
        {
          id: data.userId,
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
          hash: hash,
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
      accessToken,
      refreshToken,
      tokenExpires,
    };
  }
}
