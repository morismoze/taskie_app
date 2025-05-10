import {
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  UseGuards,
  Req,
  Delete,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthGuard } from '@nestjs/passport';
import { UserResponse } from 'src/modules/user/dto/user-response.dto';
import { JwtRefreshPayload } from './strategies/domain/jwt-refresh-payload.domain';
import { JwtPayload } from './strategies/domain/jwt-payload.domain';
import { TokenRefreshResponse } from './dto/token-refresh-response.dto';
import { Request } from 'express';

@Controller({
  path: 'auth',
})
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Get('me')
  @UseGuards(AuthGuard('jwt'))
  @HttpCode(HttpStatus.OK)
  me(@Req() request: Request & { user: JwtPayload }): Promise<UserResponse> {
    return this.authService.me(request.user);
  }

  @Post('refresh')
  @UseGuards(AuthGuard('jwt-refresh'))
  @HttpCode(HttpStatus.OK)
  refresh(
    @Req() request: Request & { user: JwtRefreshPayload },
  ): Promise<TokenRefreshResponse> {
    return this.authService.refreshToken(request.user);
  }

  @Delete('logout')
  @UseGuards(AuthGuard('jwt'))
  @HttpCode(HttpStatus.NO_CONTENT)
  public async logout(
    @Req() request: Request & { user: JwtPayload },
  ): Promise<void> {
    return this.authService.logout(request.user);
  }
}
