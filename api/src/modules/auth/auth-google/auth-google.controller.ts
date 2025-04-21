import { Body, Controller, HttpCode, HttpStatus, Post } from '@nestjs/common';
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
  async login(@Body() loginDto: AuthGoogleRequest): Promise<LoginResponse> {
    const socialData = await this.authGoogleService.getProfileByToken(loginDto);

    return this.authService.socialLogin(AuthProvider.google, socialData);
  }
}
