import { ExtractJwt, Strategy } from 'passport-jwt';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ConfigService } from '@nestjs/config';
import { AggregatedConfig } from 'src/config/config.model';
import { JwtPayload } from './models/jwt-payload.model';
import { OrNever } from 'src/common/types/or-never.type';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(configService: ConfigService<AggregatedConfig>) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: configService.get('auth.secret', { infer: true }),
    });
  }

  public validate(payload: JwtPayload): OrNever<JwtPayload> {
    if (!payload.sub) {
      throw new UnauthorizedException();
    }

    return payload;
  }
}
