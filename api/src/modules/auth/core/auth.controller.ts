import {
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Request,
  Post,
  UseGuards,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthGuard } from '@nestjs/passport';
import { UserResponse } from 'src/modules/user/dto/user-response.dto';
import { JwtRefreshPayload } from './strategies/domain/jwt-refresh-payload.domain';
import { JwtPayload } from './strategies/domain/jwt-payload.domain';
import { TokenRefreshResponse } from './dto/token-refresh-response.dto';

@Controller({
  path: 'auth',
})
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Get('me')
  @UseGuards(AuthGuard('jwt'))
  @HttpCode(HttpStatus.OK)
  me(
    @Request() request: Request & { user: JwtPayload },
  ): Promise<UserResponse> {
    return this.authService.me(request.user);
  }

  @Post('refresh')
  @UseGuards(AuthGuard('jwt-refresh'))
  @HttpCode(HttpStatus.OK)
  refresh(
    @Request() request: Request & { user: JwtRefreshPayload },
  ): Promise<TokenRefreshResponse> {
    return this.authService.refreshToken(request.user);
  }

  @Post('logout')
  @UseGuards(AuthGuard('jwt'))
  @HttpCode(HttpStatus.NO_CONTENT)
  public async logout(
    @Request() request: Request & { user: JwtPayload },
  ): Promise<void> {
    await this.authService.logout(request.user);
  }
}
