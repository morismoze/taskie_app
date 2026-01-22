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
import { JwtRefreshPayload } from './jwt-refresh-payload.type';

export const jwtRefreshStrategyName = 'jwt-refresh';

@Injectable()
export class JwtRefreshStrategy extends PassportStrategy(
  Strategy,
  jwtRefreshStrategyName,
) {
  // Calling parent constructor will:
  // 1. Automatically verifies signature
  // 2. Automatically validates standard claims:
  //  exp (expiration)
  //  nbf (not before)
  //  iat (issued at) — not strictly for validity, but still parsed
  // 3. Will reject expired tokens before validate() is even called
  // Before the below validate function is called, an inner validate function
  // is invoked, and if it fails for any reason, it will throw UnauthorizedException
  constructor(
    // Injecting SessionService directly does not work because it depends on the
    // transactional repo, which is request scoped, but strategies are
    // singletons (not request scoped). So we resolve that service with
    // ModuleRef.
    private readonly moduleRef: ModuleRef,
    configService: ConfigService<AggregatedConfig>,
    private readonly logger: AppLogger,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false, // To be explicit
      secretOrKey: configService.get('auth.refreshSecret', { infer: true })!,
      passReqToCallback: true,
    });
  }

  public async validate(
    request: Request,
    payload: JwtRefreshPayload,
  ): Promise<OrNever<JwtRefreshPayload>> {
    if (!payload.sessionId) {
      throw new UnauthorizedException();
    }

    // Security Mechanism: Refresh Token Rotation & Reuse Detection:
    // When a refresh token is used, we generate a new hash and update the session in the DB.
    // If the hash in this incoming payload does NOT match the current hash in the database,
    // it implies that:
    // 1. The token has already been used (stale).
    // 2. Or the token was stolen and the legitimate user has already rotated the hash.
    //
    // In either case, we treat this as a potential security threat (Token Reuse)
    // and reject the request immediately.
    const ctxId = ContextIdFactory.getByRequest(request);
    const sessionService = await this.moduleRef.resolve(SessionService, ctxId, {
      strict: false,
    });
    const session = await sessionService.findById(payload.sessionId);

    if (!session || session.hash !== payload.hash) {
      if (session) {
        this.logger.warn(
          {
            msg: 'Security Alert: Refresh Token Reuse Detected',
            description:
              'User tried to use an old/stale refresh token. Potential token theft.',
            sessionId: payload.sessionId,
            expectedHashPrefix: session.hash
              ? session.hash.substring(0, 4) + '...'
              : 'null',
            receivedHashPrefix: payload.hash
              ? payload.hash.substring(0, 4) + '...'
              : 'null',
          },
          JwtRefreshStrategy.name,
        );
      }

      throw new UnauthorizedException();
    }

    // Based on the way JWT signing works, we're guaranteed that we're receiving a valid token that
    // we have previously signed and issued to a valid user.

    // Passport will build a user object based on the return value of our validate()
    // method, and attach it as a property on the Request object.
    return payload;
  }
}
