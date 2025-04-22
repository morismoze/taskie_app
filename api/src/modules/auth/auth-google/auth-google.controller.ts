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
import { AuthGoogleService } from './auth-google.service';
import { AuthGoogleRequest } from './dto/google-auth-request.dto';

@Controller({
  path: 'auth/google',
})
export class AuthAppleController {
  constructor(
    private readonly authService: AuthService,
    private readonly authGoogleService: AuthGoogleService,
  ) {}

  @Post()
  @HttpCode(HttpStatus.OK)
  async login(
    @Req() request: Request,
    @Body() loginDto: AuthGoogleRequest,
  ): Promise<LoginResponse> {
    const socialData = await this.authGoogleService.getProfileByToken(loginDto);

    return this.authService.socialLogin(
      AuthProvider.google,
      socialData,
      request.ip as string,
      request.metadata.deviceId,
      request.metadata.deviceModel,
      request.metadata.osVersion,
      request.metadata.appVersion,
    );
  }
}
