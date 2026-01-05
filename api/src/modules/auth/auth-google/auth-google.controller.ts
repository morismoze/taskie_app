import {
  Body,
  Controller,
  HttpCode,
  HttpStatus,
  Post,
  Req,
} from '@nestjs/common';
import {
  ApiInternalServerErrorResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { Request } from 'express';
import { AuthService } from '../core/auth.service';
import { AuthProvider } from '../core/domain/auth-provider.enum';
import { LoginResponse } from '../core/dto/login-response.dto';
import { SocialLoginRequest } from '../core/dto/social-login-request.dto';
import { AuthGoogleService } from './auth-google.service';

@ApiTags('Auth')
@Controller({
  path: 'auth/google',
  version: '1',
})
export class AuthGoogleController {
  constructor(
    private readonly authService: AuthService,
    private readonly authGoogleService: AuthGoogleService,
  ) {}

  @Post()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Sign in with Google' })
  @ApiOkResponse({
    type: LoginResponse,
  })
  @ApiUnauthorizedResponse({
    description: 'Authentication failed',
  })
  @ApiInternalServerErrorResponse({
    description: 'Internal error while creating the user or the session',
  })
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
