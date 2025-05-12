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
import { UserResponse } from 'src/modules/user/dto/user-response.dto';
import { TokenRefreshResponse } from './dto/token-refresh-response.dto';
import { Request } from 'express';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { JwtRefreshPayload } from './strategies/jwt-refresh-payload.type';
import { JwtRefreshAuthGuard } from './guards/jwt-refresh-auth.guard';
import { RequestWithUser } from './domain/request-with-user.domain';

@Controller({
  path: 'auth',
})
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Get('me')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  me(@Req() request: RequestWithUser): Promise<UserResponse> {
    return this.authService.me(request.user);
  }

  @Post('refresh')
  @UseGuards(JwtRefreshAuthGuard)
  @HttpCode(HttpStatus.OK)
  refresh(
    @Req() request: Request & { user: JwtRefreshPayload },
  ): Promise<TokenRefreshResponse> {
    return this.authService.refreshToken(request.user);
  }

  @Delete('logout')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  public async logout(@Req() request: RequestWithUser): Promise<void> {
    return this.authService.logout(request.user);
  }
}
