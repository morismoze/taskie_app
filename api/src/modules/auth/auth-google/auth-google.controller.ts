import {
  Body,
  Controller,
  HttpCode,
  HttpStatus,
  Post,
  Req,
} from '@nestjs/common';
import { Request } from 'express';
import { AuthService } from '../core/auth.service';
import { AuthProvider } from '../core/domain/auth-provider.enum';
import { LoginResponse } from '../core/dto/login-response.dto';
import { SocialLoginRequest } from '../core/dto/social-login-request.dto';
import { AuthGoogleService } from './auth-google.service';

@Controller({
  path: 'auth/google',
})
export class AuthGoogleController {
  constructor(
    private readonly authService: AuthService,
    private readonly authGoogleService: AuthGoogleService,
  ) {}

  @Post()
  @HttpCode(HttpStatus.OK)
  async signIn(
    @Req() request: Request,
    @Body() loginDto: SocialLoginRequest,
  ): Promise<LoginResponse> {
    const socialData = await this.authGoogleService.getProfileByToken(loginDto);

    return this.authService.socialLogin({
      authProvider: AuthProvider.GOOGLE,
      socialData,
      ipAddress: request.ip as string,
      deviceModel: request.metadata.deviceModel,
      osVersion: request.metadata.osVersion,
      appVersion: request.metadata.appVersion,
    });
  }
}
