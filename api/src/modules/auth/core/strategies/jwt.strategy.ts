import { ExtractJwt, Strategy } from 'passport-jwt';
import { Injectable, Logger, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ConfigService } from '@nestjs/config';
import { AggregatedConfig } from 'src/config/config.type';
import { JwtPayload } from './jwt-payload.type';
import { OrNever } from 'src/common/types/or-never.type';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(configService: ConfigService<AggregatedConfig>) {
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
      secretOrKey: configService.get('auth.secret', { infer: true }),
    });
  }

  public validate(payload: JwtPayload): OrNever<JwtPayload> {
    if (!payload.sub) {
      throw new UnauthorizedException();
    }

    // Based on the way JWT signing works, we're guaranteed that we're receiving a valid token that
    // we have previously signed and issued to a valid user.

    const logger = new Logger(JwtStrategy.name);
    logger.error(`User ID: ${payload.sub}`);

    // Passport will build a user object based on the return value of our validate()
    // method, and attach it as a property `user` on the Request object.
    return payload;
  }
}
