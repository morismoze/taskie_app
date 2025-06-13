import {
  Controller,
  Delete,
  HttpCode,
  HttpStatus,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { Request } from 'express';
import { AuthService } from './auth.service';
import { RequestWithUser } from './domain/request-with-user.domain';
import { TokenRefreshResponse } from './dto/token-refresh-response.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { JwtRefreshAuthGuard } from './guards/jwt-refresh-auth.guard';
import { JwtRefreshPayload } from './strategies/jwt-refresh-payload.type';

@Controller({
  path: 'auth',
})
export class AuthController {
  constructor(private readonly authService: AuthService) {}

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
