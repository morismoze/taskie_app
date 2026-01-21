import { Injectable } from '@nestjs/common';
import { randomStringGenerator } from '@nestjs/common/utils/random-string-generator.util';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import * as crypto from 'crypto';
import { DateTime } from 'luxon';
import * as ms from 'ms';
import { AggregatedConfig } from 'src/config/config.type';
import { Session } from 'src/modules/session/domain/session.domain';
import { SessionService } from 'src/modules/session/session.service';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { UserStatus } from 'src/modules/user/domain/user-status.enum';
import { User } from 'src/modules/user/domain/user.domain';
import { RolePerWorkspace } from 'src/modules/user/dto/response/user-response.dto';
import { UserService } from 'src/modules/user/user.service';
import { WorkspaceUserService } from 'src/modules/workspace/workspace-user-module/workspace-user.service';
import { AuthProvider } from './domain/auth-provider.enum';
import { SocialLogin } from './domain/social-login.domain';
import { LoginResponse } from './dto/login-response.dto';
import { TokenRefreshResponse } from './dto/token-refresh-response.dto';
import { JwtPayload } from './strategies/jwt-payload.type';
import { JwtRefreshPayload } from './strategies/jwt-refresh-payload.type';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly userService: UserService,
    private readonly workspaceUserService: WorkspaceUserService,
    private readonly configService: ConfigService<AggregatedConfig>,
    private readonly sessionService: SessionService,
    private readonly unitOfWorkService: UnitOfWorkService,
  ) {}

  async socialLogin({
    authProvider,
    socialData,
    ipAddress,
    deviceModel,
    osVersion,
    appVersion,
    buildNumber,
  }: {
    authProvider: AuthProvider;
    socialData: SocialLogin;
    ipAddress: Session['ipAddress'];
    deviceModel: Session['deviceModel'];
    osVersion: Session['osVersion'];
    appVersion: Session['appVersion'];
    buildNumber: Session['buildNumber'];
  }): Promise<LoginResponse> {
    const { user, session } = await this.unitOfWorkService.withTransaction(
      async () => {
        let user = await this.userService.findBySocialIdAndProvider({
          socialId: socialData.id,
          provider: authProvider,
        });

        if (user) {
          // User has already "registered" via the social auth provider so
          // we check if there are any properties retrieved by the auth service
          // that have changed.
          let email: SocialLogin['email'] | undefined = undefined;
          let firstName: SocialLogin['firstName'] | undefined = undefined;
          let lastName: SocialLogin['lastName'] | undefined = undefined;
          let profileImageUrl: SocialLogin['profileImageUrl'] | undefined =
            undefined;

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

          if (email || firstName || lastName || profileImageUrl) {
            user = await this.userService.update({
              id: user.id,
              data: {
                email,
                firstName,
                lastName,
                profileImageUrl,
              },
            });
          }
        } else {
          // User hasn't yet "registered"
          user = await this.userService.create({
            email: socialData.email,
            firstName: socialData.firstName,
            lastName: socialData.lastName,
            socialId: socialData.id,
            provider: authProvider,
            profileImageUrl: socialData.profileImageUrl,
            status: UserStatus.ACTIVE, // since it's auth register, we activate the user immediately
          });
        }

        const hash = crypto
          .createHash('sha256')
          .update(randomStringGenerator())
          .digest('hex');

        const session = await this.sessionService.create({
          userId: user.id,
          hash,
          ipAddress,
          deviceModel,
          osVersion,
          appVersion,
          buildNumber,
        });

        return { user, session };
      },
    );

    // When user is first-time "registered", this will be empty array
    const workspaceUserMemberships =
      await this.workspaceUserService.findAllByUserIdWithWorkspace(user.id);

    const { accessToken, refreshToken, tokenExpires } =
      await this.getTokensData(
        {
          sub: user.id,
          roles: workspaceUserMemberships.map((workspaceUser) => ({
            workspaceId: workspaceUser.workspace.id,
            role: workspaceUser.workspaceRole,
          })),
          sessionId: session.id,
          atv: session.accessTokenVersion,
        },
        session.hash,
      );

    const rolesPerWorkspaces: RolePerWorkspace[] = (
      await this.workspaceUserService.findAllByUserIdWithWorkspace(user.id)
    ).map((wu) => ({
      workspaceId: wu.workspace.id,
      role: wu.workspaceRole,
    }));

    const userDto: LoginResponse['user'] = {
      email: user.email,
      firstName: user.firstName,
      id: user.id,
      lastName: user.lastName,
      roles: rolesPerWorkspaces,
      profileImageUrl: user.profileImageUrl,
      createdAt: DateTime.fromJSDate(user.createdAt).toISO()!,
    };

    return {
      refreshToken,
      accessToken,
      tokenExpires,
      user: userDto,
    };
  }

  async refreshToken(data: JwtRefreshPayload): Promise<TokenRefreshResponse> {
    // Using assertion because session should be always found based on how JWT works (custom secret)
    const session = (await this.sessionService.findByIdWithUser(
      data.sessionId,
    )) as Session;

    // Using assertion because user should be always found based on how JWT works (custom secret)
    const user = (await this.userService.findById(session.user.id)) as User;

    const workspaceUserMemberships =
      await this.workspaceUserService.findAllByUserIdWithWorkspace(user.id);

    const newHash = crypto
      .createHash('sha256')
      .update(randomStringGenerator())
      .digest('hex');

    // Invalidate the existing session with new hash
    await this.sessionService.update({
      id: session.id,
      data: { hash: newHash },
    });

    const { accessToken, refreshToken, tokenExpires } =
      await this.getTokensData(
        {
          sub: user.id,
          roles: workspaceUserMemberships.map((workspaceUser) => ({
            workspaceId: workspaceUser.workspace.id,
            role: workspaceUser.workspaceRole,
          })),
          sessionId: session.id,
          atv: session.accessTokenVersion,
        },
        newHash,
      );

    return {
      accessToken,
      refreshToken,
      tokenExpires,
    };
  }

  logout(data: JwtPayload): Promise<void> {
    return this.sessionService.deleteById(data.sessionId);
  }

  private async getTokensData(data: JwtPayload, hash: Session['hash']) {
    const tokenExpiresIn = this.configService.getOrThrow('auth.expires', {
      infer: true,
    });

    const tokenExpires = Date.now() + ms(tokenExpiresIn);

    const [accessToken, refreshToken] = await Promise.all([
      await this.jwtService.signAsync(
        {
          sub: data.sub,
          roles: data.roles,
          sessionId: data.sessionId,
          atv: data.atv,
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
