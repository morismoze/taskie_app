import { ExtractJwt, Strategy } from 'passport-jwt';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ConfigService } from '@nestjs/config';
import { AggregatedConfig } from 'src/config/config.type';
import { OrNever } from 'src/common/types/or-never.type';
import { JwtRefreshPayload } from './domain/jwt-refresh-payload.domain';

@Injectable()
export class JwtRefreshStrategy extends PassportStrategy(
  Strategy,
  'jwt-refresh',
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
  constructor(configService: ConfigService<AggregatedConfig>) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: configService.get('auth.refreshSecret', { infer: true }),
    });
  }

  public validate(payload: JwtRefreshPayload): OrNever<JwtRefreshPayload> {
    if (!payload.sessionId) {
      throw new UnauthorizedException();
    }

    return payload;
  }
}
