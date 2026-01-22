import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ContextIdFactory, ModuleRef } from '@nestjs/core';
import { PassportStrategy } from '@nestjs/passport';
import { Request } from 'express';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { OrNever } from 'src/common/types/or-never.type';
import { AggregatedConfig } from 'src/config/config.type';
import { AppLogger } from 'src/modules/logger/app-logger';
import { SessionService } from 'src/modules/session/session.service';
import { JwtPayload } from './jwt-payload.type';

export const jwtStrategyName = 'jwt';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, jwtStrategyName) {
  constructor(
    // Injecting SessionService directly does not work because it depends on the
    // transactional repo, which is request scoped, but strategies are
    // singletons (not request scoped). So we resolve that service with
    // ModuleRef.
    private readonly moduleRef: ModuleRef,
    configService: ConfigService<AggregatedConfig>,
    private readonly logger: AppLogger,
  ) {
    // Calling parent constructor:
    // 1. Automatically verifies signature
    // 2. Automatically validates standard claims:
    //  exp (expiration)
    //  nbf (not before)
    //  iat (issued at) — not strictly for validity, but still parsed
    // 3. Will reject expired tokens before validate() is even called
    // Before the below validate function is called, an inner validate function
    // is invoked, and if it fails for any reason, it will throw UnauthorizedException
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false, // To be explicit
      secretOrKey: configService.get('auth.secret', { infer: true })!,
      passReqToCallback: true,
    });
  }

  public async validate(
    request: Request,
    payload: JwtPayload,
  ): Promise<OrNever<JwtPayload>> {
    if (!payload.sub) {
      throw new UnauthorizedException();
    }

    // A non-virtual user can get his roles changed:
    // 1. directly by a Manager through the app
    // 2. when user gets removed from a workspace
    // In those two cases we need a way to make that user do token
    // refresh and user info refresh in the app. We do this using
    // access token versioning. Basically, that's a plain integer
    // field on Session entity (defaults to 0) which we increment
    // in the WorkspaceService in those two cases (endpoints).
    // We also add that value to the access token payload itself.
    // And then here we detect that increment change, comparing
    // these two values, and if the value from the access token
    // does not equal to the one on the found session record,
    // we unauthorize the user.
    // We use incremental flag and not e.g. a boolean flag,
    // because a boolean flag would require switching back
    // to default value on token refresh. This way we just
    // write the session atv value to the access token
    // at the time of login and compare it with the current
    // value at the time of JWT strategy execution.
    // We use atv and not deleting sessions, because on token
    // refresh we actually update the session with new hash.
    const ctxId = ContextIdFactory.getByRequest(request);
    const sessionService = await this.moduleRef.resolve(SessionService, ctxId, {
      strict: false,
    });
    const session = await sessionService.findById(payload.sessionId);

    if (!session) {
      throw new UnauthorizedException();
    }

    if (session.accessTokenVersion !== payload.atv) {
      this.logger.warn(
        {
          msg: 'Forced Token Invalidation (ATV Mismatch)',
          description:
            'User access token revoked due to role/permission change or logout.',
          userId: payload.sub,
          sessionId: payload.sessionId,
          tokenVersion: payload.atv,
          dbVersion: session.accessTokenVersion,
        },
        JwtStrategy.name,
      );

      throw new UnauthorizedException();
    }

    // Based on the way JWT signing works, we're guaranteed that we're receiving a
    // valid token that we have previously signed and issued to a valid user.

    // Passport will build a user object based on the return value of our validate()
    // method, and attach it as a property `user` on the Request object.
    return payload;
  }
}
