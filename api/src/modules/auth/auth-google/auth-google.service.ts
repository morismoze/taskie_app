import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { OAuth2Client } from 'google-auth-library';
import { AggregatedConfig } from 'src/modules/app-config/config/config.model';
import { SocialLoginDomain } from '../core/domain/social-response.domain';
import { AuthGoogleRequest } from './dto/google-auth-request.dto';

@Injectable()
export class AuthGoogleService {
  private google: OAuth2Client;

  constructor(private configService: ConfigService<AggregatedConfig>) {
    this.google = new OAuth2Client(
      configService.get('google.auth.clientId', { infer: true }),
      configService.get('google.auth.clientSecret', { infer: true }),
    );
  }

  async getProfileByToken(
    requestDto: AuthGoogleRequest,
  ): Promise<SocialLoginDomain> {
    const ticket = await this.google.verifyIdToken({
      idToken: requestDto.idToken,
      audience: this.configService.getOrThrow('google.auth.clientId', {
        infer: true,
      }),
    });

    const data = ticket.getPayload();

    if (!data) {
      throw new UnauthorizedException();
    }

    return {
      id: data.sub,
      email: data.email,
      firstName: data.given_name,
      lastName: data.family_name,
      profileImageUrl: data.picture,
    };
  }
}
