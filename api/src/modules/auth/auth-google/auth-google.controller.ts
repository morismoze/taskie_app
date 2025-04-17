import { Body, Controller, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { AuthService } from '../core/auth.service';
import { AuthProvider } from '../core/domain/auth-provider.enum';
import { LoginResponse } from '../core/dto/login-response.dto';
import { AuthGoogleService } from './auth-google.service';
import { AuthGoogleRequest } from './dto/google-auth-request.dto';

@Controller({
  path: 'auth/google',
  version: '1',
})
export class AuthAppleController {
  constructor(
    private readonly authService: AuthService,
    private readonly authAppleService: AuthGoogleService,
  ) {}

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Body() loginDto: AuthGoogleRequest): Promise<LoginResponse> {
    const socialData = await this.authAppleService.getProfileByToken(loginDto);

    return this.authService.socialLogin(AuthProvider.google, socialData);
  }
}
