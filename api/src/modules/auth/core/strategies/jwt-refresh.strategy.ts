import { ExtractJwt, Strategy } from 'passport-jwt';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ConfigService } from '@nestjs/config';
import { AggregatedConfig } from 'src/config/config.model';
import { OrNever } from 'src/common/types/or-never.type';
import { JwtPayload } from './models/jwt-payload.model';

@Injectable()
export class JwtRefreshStrategy extends PassportStrategy(
  Strategy,
  'jwt-refresh',
) {
  constructor(configService: ConfigService<AggregatedConfig>) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: configService.get('auth.refreshSecret', { infer: true }),
    });
  }

  public validate(
    payload: Omit<JwtPayload, 'role'>,
  ): OrNever<Omit<JwtPayload, 'role'>> {
    if (!payload.sub) {
      throw new UnauthorizedException();
    }

    return payload;
  }
}
