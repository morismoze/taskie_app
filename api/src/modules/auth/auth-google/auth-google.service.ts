import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { OAuth2Client } from 'google-auth-library';
import { AggregatedConfig } from 'src/config/config.type';
import { SocialLogin } from '../core/domain/social-login.domain';
import { SocialLoginRequest } from '../core/dto/social-login-request.dto';

@Injectable()
export class AuthGoogleService {
  private google: OAuth2Client;

  constructor(private configService: ConfigService<AggregatedConfig>) {
    this.google = new OAuth2Client(
      configService.get('google.auth.clientId', { infer: true }),
      configService.get('google.auth.clientSecret', { infer: true }),
    );
  }

  async getProfileByToken(data: SocialLoginRequest): Promise<SocialLogin> {
    const ticket = await this.google.verifyIdToken({
      idToken: data.idToken,
      audience: this.configService.getOrThrow('google.auth.clientId', {
        infer: true,
      }),
    });

    const payload = ticket.getPayload();

    if (
      !payload ||
      !payload.email ||
      !payload.given_name ||
      !payload.family_name ||
      !payload.picture
    ) {
      throw new UnauthorizedException();
    }

    return {
      id: payload.sub,
      email: payload.email!,
      firstName: payload.given_name,
      lastName: payload.family_name,
      profileImageUrl: payload.picture,
    };
  }
}
